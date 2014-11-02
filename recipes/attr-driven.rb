
node.default[:collectd][:config]="collectd"

rhel=0
case node[:platform_family]
when "rhel"
rhel=1
node.normal["collectd"]["base_dir"]="/var/lib/collectd"
end

mon=0
if node[:collectd][:collectdmon] == "true"
 mon=1
end
template "/etc/init.d/collectd" do
  source "collectd.erb"
  mode "0766"
  variables(
              :dir => node["collectd"]["base_dir"],
              :role => "collectd",
              :rhel => rhel,
              :mon => mon
            )
  notifies :restart, "service[collectd]"
end

service "collectd" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end

dashboard_ip = private_cookbook_ip("kmon")

if dashboard_ip.empty?
  raise "No servers found. Please configure at least one node with collectd::server."
end

template "/etc/collectd/alert.py" do
  source "alert.py.erb"
  owner "root"
  group "root"
  mode "755"
  variables({ :dashboard_ip => dashboard_ip })
end

template "/etc/collectd/filters/filters-generic.conf" do
  source "filters.conf.erb"
  owner "root"
  group "root"
  mode "755"
end

private_ip = my_private_ip()

template "/etc/collectd/collectd.conf" do
  source "collectd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  variables({ :dashboard_ip => dashboard_ip,
              :host_ip => private_ip
  })
  notifies :enable, resources(:service => "collectd")
  notifies :restart, resources(:service => "collectd")
end


template "/etc/collectd/collection.conf" do
  source "collection.conf.erb"   
  owner "root"
  group "root"
  mode "644"
  notifies :restart, resources(:service => "collectd")
end

template "/etc/collectd/thresholds/thresholds-generic.conf" do
  source "thresholds.conf.erb"   
  owner "root"
  group "root"
  mode "644"
  notifies :restart, resources(:service => "collectd")
end


group node['alert']['group'] do
end

user node['alert']['user'] do
  comment 'hop user for collectd alerts'
  gid node['alert']['group']
  shell '/bin/bash'
  system true
end

 kagent_config "collectd" do
   service "COLLECTD"
   start_script "#{node[:collectd][:plugin_dir]}/collectd-start.sh"
   stop_script "#{node[:collectd][:plugin_dir]}/collectd-stop.sh"
   log_file "/var/log/collectd.log"
   pid_file "/var/run/collectdmon.pid"
 end

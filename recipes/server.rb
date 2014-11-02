#include_recipe "collectd::install"

role="collectd-server"

directory "/etc/collectd/#{role}-plugins" do
  owner "root"
  group "root"
  mode "755"
end

%w(collection thresholds).each do |file|
  template "/etc/collectd/#{file}.conf" do
    source "#{file}.conf.erb"
    owner "root"
    group "root"
    mode "644"
  end
end

# collectd_plugin "network" do
#   options :listen=>'0.0.0.0'
#   options :SecurityLevel=>"Encrypt"
#   options :AuthFile=>"/etc/collectd/auth_file"
#   dir "#{role}"
# end


#collectd_plugin "rrdcached" do
#  options :DaemonAddress => "unix:/var/run/rrdcached.sock"       
#  options :DataDir => "/var/lib/collectd/rrd"
#  options :CollectStatistics => true
#  options :CreateFiles => true
#</Plugin>

# Enable caching for collectd 
# https://jeremy.visser.name/2010/02/enable-caching-in-collectd/
# collectd_plugin "rrdtool" do
#   options :data_dir=>"/var/lib/collectd/rrd"
#   options :CacheTimeout => 30
#   options :CacheFlush => 1200
#   options :WritesPerSecond => 0
#   options :RandomTimeout => 10
#   dir "#{role}"
# end

# collectd_plugin "logfile" do
#   options :LogLevel=>"info"
#   options :File=>"/var/log/collectd-server.log"
#   options :Timestamp=>true
#   dir "#{role}"
# end

Rhel=0
case node[:platform_family]
when "rhel"
  rhel=1
  node.normal["collectd"]["base_dir"]="/var/lib/collectd"
end

mon=0
if node[:collectd][:collectdmon] == "true"
  mon=1
end

template "/etc/init.d/#{role}" do
  mode "0766"
  source "collectd.erb"
  variables(
            :dir => node["collectd"]["base_dir"],
            :role => role,
            :rhel => rhel,
            :mon => mon
            )
  notifies :restart, "service[#{role}]"
end

service "#{role}" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end

private_ip = my_private_ip()

template "/etc/collectd/#{role}.conf" do
  source "#{role}.conf.erb"
  owner "root"
  group "root"
  mode "644"
  variables({ :host_ip => private_ip  })
  notifies :enable, resources(:service => "#{role}")
  notifies :restart, resources(:service => "#{role}")
end

template "/etc/collectd/auth_file" do
  source "auth_file.erb"
  owner "root"
  group "root"
  mode "600"
end

case node[:platform_family]
when "debian"

package "libdbd-mysql" do
    action :install
end

when "rhel"
package "libdbi-dbd-mysql" do
    action :install
end

end

kagent_config "collectdserver" do
  service "COLLECTD"
  start_script "#{node[:collectd][:plugin_dir]}/collectd-start.sh"
  stop_script "#{node[:collectd][:plugin_dir]}/collectd-stop.sh"
  log_file "/var/log/#{role}.log"
  pid_file "/var/run/#{role}mon.pid"
end

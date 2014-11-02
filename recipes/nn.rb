node.default[:collectd][:config]="collectd"
include_recipe "collectd::attr-driven"

dashboard_ip = private_cookbook_ip("kmon")
my_ip = my_private_ip()

template "/etc/collectd/plugins/jmx_plugin.conf" do
  source "jmx_plugin.conf.erb"
  owner "root"
  group "root"
  mode "755"
  variables({ :node_type => "nn", 
              :dashboard_ip => dashboard_ip,
              :my_ip => my_ip
 })
end

template "/etc/collectd/thresholds/thresholds-nn.conf" do
  source "thresholds-nn.conf.erb"   
  owner "root"
  group "root"
  mode "644"
end

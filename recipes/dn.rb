node.default[:collectd][:config]="collectd"
include_recipe "collectd::attr-driven"

my_ip = my_private_ip()
template "/etc/collectd/plugins/jmx_plugin.conf" do
  source "jmx_plugin.conf.erb"
  owner "root"
  group "root"
  mode "755"
  variables({ :node_type => "dn",
              :jmxpassword => node[:jmxpassword],
              :my_ip => my_ip
  })
end

template "/etc/collectd/thresholds/thresholds-dn.conf" do
  source "thresholds-dn.conf.erb"   
  owner "root"
  group "root"
  mode "644"
end


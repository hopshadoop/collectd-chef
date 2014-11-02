node.default[:collectd][:config]="collectd"
include_recipe "collectd::attr-driven"

flume_ip = private_cookbook_ip("flume")

template "/etc/collectd/plugins/flume.conf" do
  source "flume.conf.erb"
  owner "root"
  group "root"
  mode "755"
  variables({ :mysql_ip => mysql_ip })
end


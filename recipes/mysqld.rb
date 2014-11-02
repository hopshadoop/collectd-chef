node.default[:collectd][:config]="collectd"
include_recipe "collectd::attr-driven"

package "libdbd-mysql" do
case node[:platform_family]
when "debian"
  package_name "libdbd-mysql"
  options "--force-yes"
when "rhel"
  package_name "perl-DBD-MySQL"
end
end

# Set node[:mysql][:jdbc_url]
jdbc_url()

mysql_ip = private_recipe_ip("ndb", "mysqld")

template "/etc/collectd/plugins/dbi_plugin.conf" do
  source "dbi_plugin.conf.erb"
  owner "root"
  group "root"
  mode "755"
    variables({ :mysql_ip => mysql_ip })
end

template "/etc/collectd/thresholds/thresholds-mysql.conf" do
  source "thresholds-mysql.conf.erb"   
  owner "root"
  group "root"
  mode "644"
end


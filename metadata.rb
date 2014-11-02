name             "collectd"
maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon. Based on Noah Kantrowitz's cookbook: https://github.com/coderanger/chef-collectd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends           "kagent"
depends           "java"

recipe            "collectd",         "Installs a collectd client that collects host-specific info."
recipe            "collectd::server", "Installs a collectd server."
recipe            "collectd::mysqld", "Installs a collectd client that pulls data from a mysqld server."
recipe            "collectd::nn",     "Installs a collectd client that pulls data from a Hadoop NameNode."
recipe            "collectd::dn",     "Installs a collectd client that pulls data from a Hadoop DataNode."
recipe            "collectd::nm",     "Installs a collectd client that pulls data from a Hadoop NodeManager."
recipe            "collectd::rm",     "Installs a collectd client that pulls data from a Hadoop ResourceManager."

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "dashboard/private_ips",
:display_name => "Collectd Server Ip",
:description => "Ip address of the Collectd server",
:type => 'array',
:default => ""

attribute "collectd/user",
:display_name => "Username for encrypting collectd client/server comms",
:description => "Username for encrypting collectd client/server comms",
:type => 'string',
:default => ""

attribute "collectd/password",
:display_name => "Password for encrypting collectd client/server comms",
:description => "Password for encrypting collectd client/server comms",
:type => 'string',
:default => ""

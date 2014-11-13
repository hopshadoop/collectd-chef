#
# Cookbook Name:: collectd
# Attributes:: default
#
# Copyright 2010, Atari, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_attribute "kagent"
include_attribute "java"

default[:collectd][:user]                = "collectd"
default[:collectd][:group]               = "collectd"
default[:collectd][:password]            = "caramelhops"

default[:collectd][:base_dir]            = "/usr"
default[:collectd][:data_dir]            = "/var/lib/collectd/rrd"
case node[:platform_family]
when "debian"
default[:collectd][:plugin_dir]          = "/usr/lib/collectd"
default[:collectd][:types_db]            = ["/usr/share/collectd/types.db"]
when "rhel"
default[:collectd][:plugin_dir]          = "/var/lib/collectd/lib/collectd"
default[:collectd][:types_db]            = ["/var/lib/collectd/share/collectd/types.db"]
end

default[:collectd][:read_threads]        = 5

default[:collectd][:collectd_web][:hostname] = "http://localhost:9191/kmon/rest/collectd"
default[:collectd][:interval]            = 10
default[:collectd][:server]              = "localhost"

default[:collectd][:collectdmon]         = "true"

# Override config for all clients
default[:collectd][:config]              = "collectd"
default[:collectd][:data_dir]            = "/var/lib/#{default[:collectd][:config]}/rrd"
default[:collectd][:collectd_web][:path] = "/srv/#{default[:collectd][:config]}_web"

# TODO: rrdtool-cached - should install this!!
default[:collectd][:yum_packages]        = %w{ libcurl libcurl-devel rrdtool rrdtool-devel libgcrypt-devel gcc make gcc-c++ perl-devel perl-ExtUtils-MakeMaker perl-ExtUtils-Embed patch }
default[:collectd]["version"]            = "5.4.1"
default[:collectd]["url"]                = "#{default[:download_url]}/collectd-#{node["collectd"]["version"]}.tar.gz"
default[:collectd][:checksum]            = "853680936893df00bfc2be58f61ab9181fecb1cf45fc5cddcb7d25da98855f65"

default[:collectd][:collectd_web][:path] = "/srv/#{default[:collectd][:config]}_web"
default[:collectd][:interval]            = 10
default[:collectd][:clients]             = "['']"

default[:alert][:user]                   = "hopalert"
default[:alert][:group]                  = "hopalert"


# Cookbook Name:: collectd
# Recipe:: default
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

case node[:platform_family]
when "debian"
  package "collectd" do
    package_name "collectd-core"
    options "--force-yes"
  end

  package "libgcrypt11" do
    options "--force-yes"
  end
when "rhel"
  node.default[:collectd][:base_dir]="/var/lib/collectd"

  node["collectd"]["yum_packages"].each do |pkg|
    package pkg
  end

  package "libgcrypt" do
    options "--force-yes"
  end

  remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}.tar.gz" do
    source node["collectd"]["url"]
    checksum node["collectd"]["checksum"]
    action :create_if_missing
  end

  bash "install-collectd" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    tar -xzf collectd-#{node["collectd"]["version"]}.tar.gz
    cd collectd-#{node["collectd"]["version"]}
    ./configure --prefix=#{node["collectd"]["base_dir"]}
    make
    make install
  EOH
    not_if "#{node[:collectd][:base_dir]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
  end

  link "/sbin/collectd" do
    to "#{node["collectd"]["base_dir"]}/sbin/collectd"
  end

  link "/sbin/collectdmon" do
    to "#{node["collectd"]["base_dir"]}/sbin/collectdmon"
  end

end

directory node[:collectd][:data_dir] do
  owner "root"
  group "root"
  mode "755"
end

directory node[:collectd][:plugin_dir] do
  owner "root"
  group "root"
  mode "755"
end


directory "/etc/collectd" do
  owner "root"
  group "root"
  mode "755"
end

directory "/etc/collectd/plugins" do
  owner "root"
  group "root"
  mode "755"
end

directory "/etc/collectd/thresholds" do
  owner "root"
  group "root"
  mode "755"
end

directory "/etc/collectd/filters" do
  owner "root"
  group "root"
  mode "755"
end

['collectd-start.sh', 'collectd-stop.sh', 'collectd-server-start.sh', 'collectd-server-stop.sh'].each do |script|
  Chef::Log.info "Installing #{script}"
  template "#{node[:collectd][:plugin_dir]}/#{script}" do
    source "#{script}.erb"
    owner node[:collectd][:user]
    group node[:collectd][:user]
    mode 0655
  end
end 

#
# Cookbook Name:: riak-cs
#
# Copyright (c) 2013-2014 Basho Technologies, Inc.
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

include_recipe "ulimit" unless node['platform_family'] == "debian"

version_str = "#{node['stanchion']['package']['version']['major']}.#{node['stanchion']['package']['version']['minor']}.#{node['stanchion']['package']['version']['incremental']}"
base_uri = base_uri = "#{node['stanchion']['package']['url']}/#{node['stanchion']['package']['version']['major']}.#{node['stanchion']['package']['version']['minor']}/#{version_str}/"
base_filename = "stanchion-#{version_str}"
platform_version = node['platform_version'].to_i
package_version = "#{version_str}-#{node['riak_cs']['package']['version']['build']}"

case node['platform']
when "debian","ubuntu"
  packagecloud_repo "basho/riak-cs" do
    type "deb"
  end

  package "stanchion" do
    action :install
    version package_version
  end
when "redhat","centos"
  if node['platform'] == "amazon" && platform_version >= 2013
    platform_version = 6
  elsif node['platform'] == "amazon"
    platform_version = 5
  end

  packagecloud_repo "basho/riak-cs" do
    type "rpm"
  end

  if platform_version >= 6
    package_version = "#{package_version}.el#{platform_version}"
  end

  package "stanchion" do
    action :install
    version package_version
  end
when "fedora"
  machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  base_uri = "#{base_uri}#{node['platform']}/#{platform_version}/"
  package_file = "#{base_filename}-#{node['stanchion']['package']['version']['build']}.fc#{platform_version}.#{node['kernel']['machine']}.rpm"
  package_uri = base_uri + package_file
  package_name = package_file.split("[-_]\d+\.").first

  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source package_uri
    owner "root"
    mode 0644
    not_if { File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") }
  end

  package package_name do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
    action :install
  end
  when "amazon"
  if node['platform'] == "amazon" && platform_version >= 2013
    platform_version = 6
  elsif node['platform'] == "amazon"
    platform_version = 5
  end

  machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  base_uri = "#{base_uri}#{node['platform_family']}/#{platform_version}/"
  package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.el#{platform_version}.#{node['kernel']['machine']}.rpm"
  package_uri = base_uri + package_file
  package_name = package_file.split("[-_]\d+\.").first

  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source package_uri
    owner "root"
    mode 0644
    not_if { File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") }
  end  

  package package_name do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
    action :install
  end
end

file "#{node['stanchion']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['stanchion']['config'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[stanchion]"
end

file "#{node['stanchion']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['stanchion']['args'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[stanchion]"
end

if node['platform_family'] == "debian"
  file "/etc/default/stanchion" do
    content "ulimit -n #{node['stanchion']['limits']['nofile']}"
    owner "root"
    mode 0644
    action :create_if_missing
    notifies :restart, "service[stanchion]"
  end
else
  user_ulimit "stanchion" do
    filehandle_limit node['stanchion']['limits']['nofile']
  end
end

service "stanchion" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end

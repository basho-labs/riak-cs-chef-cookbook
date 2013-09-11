#
# Author:: Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak-cs
# Recipe:: enterprise_package
#
# Copyright (c) 2013 Basho Technologies, Inc.
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

version_str = "#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}.#{node['riak_cs']['package']['version']['incremental']}"
base_uri = "http://private.downloads.basho.com/riak-cs-ee/#{node['riak_cs']['package']['enterprise_key']}/#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}/#{version_str}/"
base_filename = "riak-cs-ee-#{version_str}"
checksum_val = node['riak_cs']['package']['checksum'][node['platform']][node['platform_version']]

case node['riak_cs']['package']['type']
  when "binary"
    case node['platform']
    when "ubuntu"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
      package_file = "#{base_filename.sub(/ee-/,'ee_')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "debian"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename.sub(/ee-/,'ee_')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "redhat", "centos", "scientific", "amazon"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}rhel/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.el#{node['platform_version'].to_i}.#{machines[node['kernel']['machine']]}.rpm"
    when "fedora"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
    end
  end

package_uri = base_uri + package_file
package_name = package_file.split("[-_]\d+\.").first

remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
  source package_uri
  checksum checksum_val
  owner "root"
  mode 0644
end

directory node['riak_cs']['package']['config_dir'] do
  owner "root"
  mode "0755"
  action :create
end

package package_name do
  source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  action :install
  options "--force-confdef --force-confold" if node['platform_family'] == "debian"
  provider value_for_platform_family(
    [ "debian" ] => Chef::Provider::Package::Dpkg,
    [ "rhel", "fedora" ] => Chef::Provider::Package::Rpm
  )
end

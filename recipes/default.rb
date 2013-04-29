#
# Author:: Sean Carey (<densone@basho.com>), Seth Thomas (<sthomas@basho.com>)
# Cookbook Name:: riak-cs
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
include_recipe "ulimit" unless node['platform_family'] == "debian"

version_str = "#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}.#{node['riak_cs']['package']['version']['incremental']}"
base_uri = "http://s3.amazonaws.com/downloads.basho.com/riak-cs/#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}/#{version_str}/"
base_filename = "riak-cs-#{version_str}"

case node['riak_cs']['package']['type']
  when "binary"
    case node['platform']
    when "ubuntu"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
      package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "debian"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/squeeze/"
      package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
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
  owner "root"
  mode 0644
  not_if { File.exists?("#{Chef::Config[:file_cache_path]}#{package_file}") }
end

directory node['riak_cs']['package']['config_dir'] do
  owner "root"
  mode "0755"
  action :create
end

package package_name do
  source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  provider value_for_platform(
    [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
    [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
  )
  case node['platform'] when "ubuntu","debian"
    options "--force-confdef --force-confold"
  end
  action :install
end

file "#{node['riak_cs']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['riak_cs']['config'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak-cs]"
end

file "#{node['riak_cs']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['riak_cs']['args'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak-cs]"
end

if node['platform_family'] == "debian"
  file "/etc/default/riak-cs" do
    content "ulimit -n #{node['riak_cs']['limits']['nofile']}"
    owner "root"
    mode 0644
    action :create_if_missing
    notifies :restart, "service[riak-cs]"
  end
else
  user_ulimit "riakcs" do
    filehandle_limit node['riak_cs']['limits']['nofile']
  end
end

service "riak-cs" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
end

#
# Author::Sean Carey (<densone@basho.com>)
# Cookbook Name:: cs
#
# Copyright (c) 2012 Basho Technologies, Inc.
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

version_str = "#{node['cs']['package']['version']['major']}.#{node['cs']['package']['version']['minor']}.#{node['cs']['package']['version']['incremental']}"
base_uri = "http://private.downloads.basho.com/riak-cs/#{node['cs']['package']['secret_hash']}/#{version_str}/"
base_filename = "riak-cs-#{version_str}"
  
case node['cs']['package']['type']
  when "binary"
    case node['platform']
    when "ubuntu"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
      package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"  
    when "debian"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/squeeze/"
      package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "redhat","centos"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}rhel/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['cs']['package']['version']['build']}.el#{node['platform_version'].to_i}.#{machines[node['kernel']['machine']]}.rpm"
    when "fedora"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['cs']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
    end
  when "source"
    package_file = "#{base_filename.sub(/\-/, '_')}.tar.gz"
  end

package_uri = base_uri + package_file

package_name = package_file.split("[-_]\d+\.").first

group "riak"

user "riakcs" do
  gid "riak"
  shell "/bin/bash"
  home "/var/lib/riak-cs"
  system true
end

directory "/tmp/cs_pkg" do
  owner "root"
  mode 0755
  action :create
end

remote_file "/tmp/cs_pkg/#{package_file}" do
  source package_uri
  owner "root"
  mode 0644
  checksum node['cs']['package']['source_checksum']
  not_if { File.exists?("/tmp/cs_pkg/#{package_file}") }
end

directory node['cs']['package']['config_dir'] do
  owner "root"
  mode "0755"
  action :create
end

# workaround deb issue by creating file in config dir
#file "#{node['cs']['package']['config_dir']}/touch" do
#  owner "root"
#  mode "0755"
#  action :create
#end

package package_name do
  source "/tmp/cs_pkg/#{package_file}"
  provider value_for_platform(
    [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
    [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
  )
  case node['platform'] when "ubuntu","debian"
    options "--force-confdef --force-confold" 
  end
  action :install
end

# cleanup workaround
#file "#{node['cs']['package']['config_dir']}/touch" do
#  action :delete
#end

file "#{node['cs']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['cs']['config'].to_hash).pp
  owner "root"
  mode 0644
end

file "#{node['cs']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['cs']['args'].to_hash).pp
  owner "root"
  mode 0644
end


service "riak-cs" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:file => [ "#{node['cs']['package']['config_dir']}/app.config",
                                   "#{node['cs']['package']['config_dir']}/vm.args" ])
end


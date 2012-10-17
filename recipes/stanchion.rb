#
# Author::Sean Carey (<densone@basho.com>)
# Cookbook Name:: riak_cs
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

# riak-cs and stanchion are always released in step, hence using the cs version attributes
version_str = "#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}.#{node['riak_cs']['package']['version']['incremental']}"
base_uri = "http://private.downloads.basho.com/stanchion/#{node['riak_cs']['package']['secret_hash']}/#{version_str}/"
base_filename = "stanchion-#{version_str}"

case node['stanchion']['package']['type']
  when "binary"  
    case node['platform']
    when "ubuntu"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
      package "libssl0.9.8"
      package_file = "#{base_filename.gsub(/\-/, '_')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"  
    when "debian"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/squeeze/"
      package_file = "#{base_filename.gsub(/\-/, '_')}-#{node['riak_cs']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "redhat","centos"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}rhel/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.el#{node['platform_version'].to_i}.#{machines[node['kernel']['machine']]}.rpm"
    when "fedora"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
    end
  when "source"
    package_file = "#{base_filename.sub(/\-/, '_')}.tar.gz"
    node['stanchion']['package']['prefix'] = "/usr/local"
    node['stanchion']['package']['config_dir'] = node['stanchion']['package']['prefix'] + "/stanchion/etc"
  end

package_uri = base_uri + package_file

package_name = package_file.split("[-_]\d+\.").first

group "stanchion"

user "stanchion" do
  gid "stanchion"
  shell "/bin/bash"
  home "/var/lib/stanchion"
  system true
end

directory "/tmp/stanchion_pkg" do
  owner "root"
  mode 0755
  action :create
end

remote_file "/tmp/stanchion_pkg/#{package_file}" do
  source package_uri
  owner "root"
  mode 0644
  checksum node['stanchion']['package']['source_checksum']
  not_if { File.exists?("/tmp/stanchion_pkg/#{package_file}") }
end

case node['stanchion']['package']['type']
when "binary"
  package package_name do
    source "/tmp/stanchion_pkg/#{package_file}"
    action :install
    options case node['platform']
            when "debian","ubuntu"
              "--force-confdef --force-confold"
            end       
    provider value_for_platform(
      [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
      [ "redhat", "centos", "fedora" ] => {"default" => Chef::Provider::Package::Rpm}
    )
  end
when "source"
  execute "stanchion-src-unpack" do
    cwd "/tmp/stanchion_pkg"
    command "tar xvfz #{package_file}"
  end

  execute "stanchion-src-build" do
    cwd "/tmp/stanchion_pkg/#{base_filename.sub(/\-/, '_')}"
    command "make clean all rel"
  end

  execute "stanchion-src-install" do
    command "mv /tmp/riak_pkg/#{base_filename.sub(/\-/, '_')}/rel/stanchion #{node['stanchion']['package']['prefix']}"
    not_if { File.directory?("#{node['stanchion']['package']['prefix']}/stanchion") }
  end
end

directory node['stanchion']['package']['config_dir'] do
  owner "root"
  mode 0755
  action :create
end

file "#{node['stanchion']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['stanchion']['config'].to_hash).pp
  owner "root"
  mode 0644
end

file "#{node['stanchion']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['stanchion']['args'].to_hash).pp
  owner "root"
  mode 0644
end

service "stanchion" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:file => [ "#{node['stanchion']['package']['config_dir']}/app.config",
                                   "#{node['stanchion']['package']['config_dir']}/vm.args" ])
end

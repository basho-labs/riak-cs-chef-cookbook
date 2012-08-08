#
# Author::Sean Carey (<densone@basho.com>)
# Cookbook Name:: cs
#
# Copyright (c) 2011 Basho Technologies, Inc.
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

if node[:cs][:package][:url]
  package_uri = node[:cs][:package][:url]
  package_file = package_uri.split("/").last
else
  version_str = "#{node[:cs][:package][:version][:major]}.#{node[:cs][:package][:version][:minor]}"
  base_uri = "http://private.downloads.basho.com/riak-cs/#{node[:cs][:package][:secret_hash]}/#{version_str}.#{node[:cs][:package][:version][:incremental]}/"
  base_filename = "riak-cs-#{version_str}.#{node[:cs][:package][:version][:incremental]}"
  
  case node[:platform]
  when "debian","ubuntu"
    machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
    base_uri = "#{base_uri}ubuntu/#{node[:lsb][:codename]}/" if [:platform_version]!="11.10"
  when "redhat","centos","scientific","fedora","suse"
    machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
    base_uri = "#{base_uri}#{node[:platform_family]}/#{node[:platform_version].to_i}/"
  end
  package_file =  case node[:cs][:package][:type]
                  when "binary"
                    case node[:platform]
                    when "debian","ubuntu"
                      "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node[:cs][:package][:version][:build]}_#{machines[node[:kernel][:machine]]}.deb"
                    when "centos","redhat","suse"
                      if node[:platform_version].to_i == 6
                        "#{base_filename}-#{node[:cs][:package][:version][:build]}.el6.#{machines[node[:kernel][:machine]]}.rpm"
                      else
                        "#{base_filename}-#{node[:cs][:package][:version][:build]}.el5.#{machines[node[:kernel][:machine]]}.rpm"
                      end
                    when "fedora"
                      "#{base_filename}-#{node[:cs][:package][:version][:build]}.fc13.#{node[:kernel][:machine]}.rpm"
                    end
                  when "source"
                    "{base_filename}.tar.gz"
                  end
  package_uri = base_uri + package_file
end

package_name = package_file.split("[-_]\d+\.").first

group "riak"

user "riak" do
  gid "riak"
  shell "/bin/bash"
  home "/var/lib/riak"
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
  checksum node[:cs][:package][:source_checksum]
  not_if { File.exists?("/tmp/cs_pkg/#{package_file}") }
end

directory node[:cs][:package][:config_dir] do
  owner "root"
  mode "0755"
  action :create
end

# workaround deb issue by creating file in config dir
file "#{node[:cs][:package][:config_dir]}/touch" do
  owner "root"
  mode "0755"
  action :create
end

package package_name do
  source "/tmp/cs_pkg/#{package_file}"
  provider value_for_platform(
    [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
    [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
  )
  case node[:platform] when "ubuntu","debian"
    options "--force-confdef --force-confold" 
  end
  action :install
end

# cleanup workaround
file "#{node[:cs][:package][:config_dir]}/touch" do
  action :delete
end

template "#{node[:cs][:package][:config_dir]}/app.config" do
  source "app.config.erb"
  owner "root"
  mode 0644
end

template "#{node[:cs][:package][:config_dir]}/vm.args" do
  variables :switches => setup_vm_args(node[:cs][:erlang])
  source "vm.args.erb"
  owner "root"
  mode 0644
end


service "riak-cs" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:template => [ "#{node[:cs][:package][:config_dir]}/app.config",
                                   "#{node[:cs][:package][:config_dir]}/vm.args" ])
end


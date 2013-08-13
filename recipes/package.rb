#
# Author:: Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak-cs
# Recipe:: package
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
base_uri = "#{node['riak_cs']['package']['url']}/#{node['riak_cs']['package']['version']['major']}.#{node['riak_cs']['package']['version']['minor']}/#{version_str}/"
base_filename = "riak-cs-#{version_str}"

case node['platform_family']
when "debian"
  include_recipe "apt"

  apt_repository "basho" do
    uri "http://apt.basho.com"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://apt.basho.com/gpg/basho.apt.key"
  end

  package "riak-cs" do
    action :install
  end
when "rhel"
  include_recipe "yum"

  yum_key "RPM-GPG-KEY-basho" do
    url "http://yum.basho.com/gpg/RPM-GPG-KEY-basho"
    action :add
  end

  yum_repository "basho" do
    repo_name "basho"
    description "Basho Stable Repo"
    url "http://yum.basho.com/el/#{node['platform_version'].to_i}/products/x86_64/"
    key "RPM-GPG-KEY-basho"
    action :add
  end

  package "riak-cs" do
    action :install
  end
when "fedora"
  machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
  package_file = "#{base_filename}-#{node['riak_cs']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
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

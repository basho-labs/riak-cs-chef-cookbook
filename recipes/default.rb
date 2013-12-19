#
# Author:: Sean Carey (<densone@basho.com>), Seth Thomas (<sthomas@basho.com>),
#          Hector Castro (<hector@basho.com>)
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

if node['riak_cs']['package']['enterprise_key'].empty?
  include_recipe "riak-cs::package"
else
  include_recipe "riak-cs::enterprise_package"
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
  action [ :enable, :start ]
end

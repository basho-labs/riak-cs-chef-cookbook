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

node.default["sysctl"]["params"]["vm"]["swappiness"] = node['riak_cs']['sysctl']['vm']['swappiness']
node.default["sysctl"]["params"]["net"]["core"]["wmem_default"] = node['riak_cs']['sysctl']['net']['core']['wmem_default']
node.default["sysctl"]["params"]["net"]["core"]["rmem_default"] = node['riak_cs']['sysctl']['net']['core']['rmem_default']
node.default["sysctl"]["params"]["net"]["core"]["wmem_max"] = node['riak_cs']['sysctl']['net']['core']['wmem_max']
node.default["sysctl"]["params"]["net"]["core"]["rmem_max"] = node['riak_cs']['sysctl']['net']['core']['rmem_max']
node.default["sysctl"]["params"]["net"]["core"]["netdev_max_backlog"] = node['riak_cs']['sysctl']['net']['core']['netdev_max_backlog']
node.default["sysctl"]["params"]["net"]["core"]["somaxconn"] = node['riak_cs']['sysctl']['net']['core']['somaxconn']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_max_syn_backlog"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_max_syn_backlog']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_timestamps"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_timestamps']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_sack"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_sack']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_window_scaling"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_window_scaling']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_fin_timeout"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_fin_timeout']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_keepalive_intvl"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_keepalive_intvl']
node.default["sysctl"]["params"]["net"]["ipv4"]["tcp_tw_reuse"] = node['riak_cs']['sysctl']['net']['ipv4']['tcp_tw_reuse']


service "riak-cs" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end

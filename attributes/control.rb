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

#package
default['riak_cs_control']['package']['url'] = "http://s3.amazonaws.com/downloads.basho.com/riak-cs-control"
default['riak_cs_control']['package']['type'] = "binary"
default['riak_cs_control']['package']['version']['major'] = "1"
default['riak_cs_control']['package']['version']['minor'] = "0"
default['riak_cs_control']['package']['version']['incremental'] = "2"
default['riak_cs_control']['package']['version']['build'] = "1"
default['riak_cs_control']['package']['config_dir'] = "/etc/riak-cs-control"

#vm.args
default['riak_cs_control']['args']['-name'] = "riak-cs-control@#{node['ipaddress']}"
default['riak_cs_control']['args']['-setcookie'] = "riak-cs-control"
default['riak_cs_control']['args']['+K'] = true
default['riak_cs_control']['args']['+A'] = 64
default['riak_cs_control']['args']['+W'] = "w"
default['riak_cs_control']['args']['-env']['ERL_MAX_PORTS'] = 4096
default['riak_cs_control']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
default['riak_cs_control']['args']['-env']['ERL_CRASH_DUMP'] = "/var/log/riak-cs/erl_crash.dump"

#app.config
class ::String
  include Eth::Erlang::String
end

class ::Array
  include Eth::Erlang::Array
end

#riak_cs_control
default['riak_cs_control']['config']['riak_cs_control']['port'] = 8000
default['riak_cs_control']['config']['riak_cs_control']['cs_hostname'] = "s3.amazonaws.com".to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_port'] = 80
default['riak_cs_control']['config']['riak_cs_control']['cs_protocol'] = "http".to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_host'] = node['ipaddress'].to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_port'] = 8080
default['riak_cs_control']['config']['riak_cs_control']['cs_admin_key'] = "admin-key".to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_admin_secret'] = "admin-secret".to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_administration_bucket'] = "riak-cs".to_erl_string

#lager
error_log = ["/var/log/riak-cs-control/error.log".to_erl_string,"error",10485760,"$D0".to_erl_string,5].to_erl_tuple
info_log = ["/var/log/riak-cs-control/console.log".to_erl_string,"info",10485760,"$D0".to_erl_string,5].to_erl_tuple
default['riak_cs_control']['config']['lager']['handlers']['lager_file_backend'] = [error_log, info_log]
default['riak_cs_control']['config']['lager']['crash_log'] = "/var/log/riak-cs-control/crash.log".to_erl_string
default['riak_cs_control']['config']['lager']['crash_log_msg_size'] = 65536
default['riak_cs_control']['config']['lager']['crash_log_size'] = 10485760
default['riak_cs_control']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
default['riak_cs_control']['config']['lager']['crash_log_count'] = 5
default['riak_cs_control']['config']['lager']['error_logger_redirect'] = true

#sasl
default['riak_cs_control']['config']['sasl']['sasl_error_logger'] = false

#limits
default['riak_cs_control']['limits']['maxfiles']['soft'] = 4096
default['riak_cs_control']['limits']['maxfiles']['hard'] = 4096
default['riak_cs_control']['limits']['config_limits'] = false

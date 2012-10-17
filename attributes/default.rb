#
# Author::Seth Thomas (<sthomas@basho.com>)
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

# vm.args
default['riak_cs']['args']['-name'] = "riak-cs@#{node['ipaddress']}"
default['riak_cs']['args']['-setcookie'] = "riak-cs"
default['riak_cs']['args']['+K'] = true
default['riak_cs']['args']['+A'] = 64
default['riak_cs']['args']['+W'] = "w"
default['riak_cs']['args']['-env']['ERL_MAX_PORTS'] = 4096
default['riak_cs']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
default['riak_cs']['args']['-env']['ERL_CRASH_DUMP'] = "/var/log/riak-cs/erl_crash.dump"

# app.config
class ::String
  include Eth::Erlang::String
end

class ::Array
  include Eth::Erlang::Array
end

#riak_moss
default['riak_cs']['config']['riak_moss']['moss_ip'] = "#{node['ipaddress']}".to_erl_string
default['riak_cs']['config']['riak_moss']['moss_port'] = 8080
default['riak_cs']['config']['riak_moss']['put_fsm_buffer_size_max'] = 10485760
default['riak_cs']['config']['riak_moss']['riak_ip'] = "#{node['ipaddress']}".to_erl_string
default['riak_cs']['config']['riak_moss']['riak_pb_port'] = 8087
default['riak_cs']['config']['riak_moss']['auth_bypass'] = false
default['riak_cs']['config']['riak_moss']['moss_root_host'] = "s3.amazonaws.com".to_erl_string
default['riak_cs']['config']['riak_moss']['connection_pools']['request_pool'] = [128,0].to_erl_tuple
default['riak_cs']['config']['riak_moss']['connection_pools']['bucket_list_pool'] = [5,0].to_erl_tuple
default['riak_cs']['config']['riak_moss']['admin_key'] = "admin-key".to_erl_string
default['riak_cs']['config']['riak_moss']['admin_secret'] = "admin-secret".to_erl_string
default['riak_cs']['config']['riak_moss']['stanchion_ip'] = "#{node['ipaddress']}".to_erl_string
default['riak_cs']['config']['riak_moss']['stanchion_port'] = 8085
default['riak_cs']['config']['riak_moss']['stanchion_ssl'] = false
default['riak_cs']['config']['riak_moss']['access_log_flush_factor'] = 1
default['riak_cs']['config']['riak_moss']['access_log_flush_size'] = 1000000
default['riak_cs']['config']['riak_moss']['access_archive_period'] = 3600
default['riak_cs']['config']['riak_moss']['access_archiver_max_backlog'] = 2
default['riak_cs']['config']['riak_moss']['storage_schedule'] = [].to_erl_list
default['riak_cs']['config']['riak_moss']['storage_archive_period'] = 86400
default['riak_cs']['config']['riak_moss']['usage_request_limit'] = 744
default['riak_cs']['config']['riak_moss']['riak_cs_stat'] = true
default['riak_cs']['config']['riak_moss']['leeway_seconds'] = 86400
default['riak_cs']['config']['riak_moss']['gc_interval'] = 900
default['riak_cs']['config']['riak_moss']['gc_retry_interval'] = 21600
default['riak_cs']['config']['riak_moss']['dtrace_support'] = false

#webmachine
default['riak_cs']['config']['webmachine']['webmachine_logger_module'] = "riak_moss_access_logger"

# lager
error_log = ["/var/log/riak-cs/error.log".to_erl_string,"error",10485760,"$D0".to_erl_string,5].to_erl_tuple
info_log = ["/var/log/riak-cs/console.log".to_erl_string,"info",10485760,"$D0".to_erl_string,5].to_erl_tuple
default['riak_cs']['config']['lager']['handlers']['lager_file_backend'] = [error_log, info_log]
default['riak_cs']['config']['lager']['crash_log'] = "/var/log/riak-cs/crash.log".to_erl_string
default['riak_cs']['config']['lager']['crash_log_msg_size'] = 65536
default['riak_cs']['config']['lager']['crash_log_size'] = 10485760
default['riak_cs']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
default['riak_cs']['config']['lager']['crash_log_count'] = 5
default['riak_cs']['config']['lager']['error_logger_redirect'] = true

#sasl
default['riak_cs']['config']['sasl']['sasl_error_logger'] = false
default['riak_cs']['config']['sasl']['utc_log'] = true

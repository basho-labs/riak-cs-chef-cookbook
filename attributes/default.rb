#
# Cookbook Name:: riak-cs
#
# Copyright (c) 2012-2014 Basho Technologies, Inc.
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

#riak_cs
default['riak_cs']['config']['riak_cs']['cs_ip'] = node['ipaddress'].to_erl_string
default['riak_cs']['config']['riak_cs']['cs_port'] = 8080
default['riak_cs']['config']['riak_cs']['riak_ip'] = node['ipaddress'].to_erl_string
default['riak_cs']['config']['riak_cs']['riak_pb_port'] = 8087
default['riak_cs']['config']['riak_cs']['stanchion_ip'] = node['ipaddress'].to_erl_string
default['riak_cs']['config']['riak_cs']['stanchion_port'] = 8085
default['riak_cs']['config']['riak_cs']['stanchion_ssl'] = false
default['riak_cs']['config']['riak_cs']['anonymous_user_creation'] = false
default['riak_cs']['config']['riak_cs']['admin_key'] = "admin-key".to_erl_string
default['riak_cs']['config']['riak_cs']['admin_secret'] = "admin-secret".to_erl_string
#default['riak_cs']['config']['riak_cs']['admin_ip'] = node['ipaddress'].to_erl_string
#default['riak_cs']['config']['riak_cs']['admin_port'] = 8000
#default['riak_cs']['config']['riak_cs']['ssl'] = [["certfile", "./etc/cert.pem".to_erl_string].to_erl_tuple, ["keyfile", "./etc/key.pem".to_erl_string].to_erl_tuple]
default['riak_cs']['config']['riak_cs']['cs_root_host'] = "s3.amazonaws.com".to_erl_string
default['riak_cs']['config']['riak_cs']['connection_pools']['request_pool'] = [128,0].to_erl_tuple
default['riak_cs']['config']['riak_cs']['connection_pools']['bucket_list_pool'] = [5,0].to_erl_tuple
default['riak_cs']['config']['riak_cs']['rewrite_module'] = "riak_cs_s3_rewrite"
default['riak_cs']['config']['riak_cs']['auth_module'] = "riak_cs_s3_auth"
default['riak_cs']['config']['riak_cs']['fold_objects_for_list_keys'] = false
default['riak_cs']['config']['riak_cs']['n_val_1_get_requests'] = true
default['riak_cs']['config']['riak_cs']['cs_version'] = 10300
default['riak_cs']['config']['riak_cs']['access_log_flush_factor'] = 1
default['riak_cs']['config']['riak_cs']['access_log_flush_size'] = 1000000
default['riak_cs']['config']['riak_cs']['access_archive_period'] = 3600
default['riak_cs']['config']['riak_cs']['access_archiver_max_backlog'] = 2
default['riak_cs']['config']['riak_cs']['storage_schedule'] = [].to_erl_list
default['riak_cs']['config']['riak_cs']['storage_archive_period'] = 86400
default['riak_cs']['config']['riak_cs']['usage_request_limit'] = 744
default['riak_cs']['config']['riak_cs']['leeway_seconds'] = 86400
default['riak_cs']['config']['riak_cs']['gc_interval'] = 900
default['riak_cs']['config']['riak_cs']['gc_paginated_indexes'] = true
default['riak_cs']['config']['riak_cs']['gc_retry_interval'] = 21600
default['riak_cs']['config']['riak_cs']['trust_x_forwarded_for'] = false
default['riak_cs']['config']['riak_cs']['dtrace_support'] = false
default['riak_cs']['config']['riak_cs']['max_buckets_per_user'] = 100

#webmachine
default['riak_cs']['config']['webmachine']['server_name'] = "Riak CS".to_erl_string
default['riak_cs']['config']['webmachine']['log_handlers']['webmachine_log_handler'] = ["/var/log/riak-cs".to_erl_string].to_erl_list
default['riak_cs']['config']['webmachine']['log_handlers']['riak_cs_access_log_handler'] = [].to_erl_list


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

# limits
default['riak_cs']['limits']['nofile'] = 4096

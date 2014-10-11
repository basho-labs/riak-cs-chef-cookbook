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
default['stanchion']['package']['url'] = "http://s3.amazonaws.com/downloads.basho.com/stanchion"
default['stanchion']['package']['type'] = "binary"
default['stanchion']['package']['version']['major'] = "1"
default['stanchion']['package']['version']['minor'] = "5"
default['stanchion']['package']['version']['incremental'] = "0"
default['stanchion']['package']['version']['build'] = "1"
default['stanchion']['package']['config_dir'] = "/etc/stanchion"

#vm.args
default['stanchion']['args']['-name'] = "stanchion@#{node['ipaddress']}"
default['stanchion']['args']['-setcookie'] = "stanchion"
default['stanchion']['args']['+K'] = true
default['stanchion']['args']['+A'] = 64
default['stanchion']['args']['+W'] = "w"
default['stanchion']['args']['-env']['ERL_MAX_PORTS'] = 4096
default['stanchion']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
default['stanchion']['args']['-env']['ERL_CRASH_DUMP'] = "/var/log/stanchion/erl_crash.dump"

class ::String
  include Eth::Erlang::String
end

class ::Array
  include Eth::Erlang::Array
end

#stanchion
default['stanchion']['config']['stanchion']['stanchion_ip'] = node['ipaddress'].to_erl_string
default['stanchion']['config']['stanchion']['stanchion_port'] = 8085
#default['stanchion']['config']['stanchion']['ssl'] = [["certfile", "./etc/cert.pem".to_erl_string].to_erl_tuple, ["keyfile", "./etc/key.pem".to_erl_string].to_erl_tuple]
default['stanchion']['config']['stanchion']['auth_bypass'] = false
default['stanchion']['config']['stanchion']['riak_ip'] = node['ipaddress'].to_erl_string
default['stanchion']['config']['stanchion']['riak_pb_port'] = 8087
default['stanchion']['config']['stanchion']['admin_key'] = "admin-key".to_erl_string
default['stanchion']['config']['stanchion']['admin_secret'] = "admin-secret".to_erl_string

#lager
error_log = ["/var/log/stanchion/error.log".to_erl_string,"error",10485760,"$D0".to_erl_string,5].to_erl_tuple
info_log = ["/var/log/stanchion/console.log".to_erl_string,"info",10485760,"$D0".to_erl_string,5].to_erl_tuple
default['stanchion']['config']['lager']['handlers']['lager_file_backend'] = [error_log, info_log]
default['stanchion']['config']['lager']['crash_log'] = "/var/log/stanchion/crash.log".to_erl_string
default['stanchion']['config']['lager']['crash_log_msg_size'] = 65536
default['stanchion']['config']['lager']['crash_log_size'] = 10485760
default['stanchion']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
default['stanchion']['config']['lager']['crash_log_count'] = 5
default['stanchion']['config']['lager']['error_logger_redirect'] = true

#sasl
default['stanchion']['config']['sasl']['sasl_error_logger'] = false
default['stanchion']['config']['sasl']['utc_log'] = true

# limits
default['stanchion']['limits']['nofile'] = 4096

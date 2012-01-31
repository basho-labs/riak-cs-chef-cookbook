#
# Author::Sean Carey (<densone@basho.com>)
# Cookbook Name:: moss
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

default.moss.erlang.node_name = "moss@#{node.ipaddress}"
default.moss.erlang.cookie = "moss"
default.moss.erlang.kernel_polling = true
default.moss.erlang.async_threads = 64
default.moss.erlang.error_logger_warnings = :w
default.moss.erlang.env_vars.ERL_MAX_PORTS = 4096
default.moss.erlang.env_vars.ERL_FULLSWEEP_AFTER = 0
default.moss.erlang.env_vars.ERL_CRASH_DUMP = "/var/log/riak_moss/erl_crash.dump"

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

default.cs.riak_moss.moss_ip = "127.0.0.1"
default.cs.riak_moss.moss_port = 8080
default.cs.riak_moss.riak_ip = "127.0.0.1"
default.cs.riak_moss.riak_pb_port = 8087
default.cs.riak_moss.auth_bypass = false
default.cs.riak_moss.moss_root_host = "s3.amazonaws.com"
default.cs.riak_moss.put_fsm_buffer_size_max = 10485760
default.cs.riak_moss.stanchion_ip = "127.0.0.1"
default.cs.riak_moss.stanchion_port = 8085
default.cs.riak_moss.stanchion_ssl = false
default.cs.riak_moss.admin_key = "admin-key"
default.cs.riak_moss.admin_secret = "admin-secret"

default.cs.riak_moss.riakc_pool = :"{128,0}"
default.cs.riak_moss.access_log_flush_factor = 1
default.cs.riak_moss.access_archive_period = 3600
default.cs.riak_moss.storage_schedule = []
default.cs.riak_moss.storage_archive_period = 86400

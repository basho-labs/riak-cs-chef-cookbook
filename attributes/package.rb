#
# Author::Sean Carey (<densone@basho.com>), Seth Thomas (<sthomas@basho.com>)
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

default['riak_cs']['package']['url'] = "http://s3.amazonaws.com/downloads.basho.com/riak-cs"
default['riak_cs']['package']['type'] = "binary"
default['riak_cs']['package']['version']['major'] = "1"
default['riak_cs']['package']['version']['minor'] = "3"
default['riak_cs']['package']['version']['incremental'] = "1"
default['riak_cs']['package']['version']['build'] = "1"
default['riak_cs']['package']['config_dir'] = "/etc/riak-cs"

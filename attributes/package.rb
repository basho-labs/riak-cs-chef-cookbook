#
# Author::Sean Carey (<densone@basho.com>)
# Cookbook Name:: cs
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

default['cs']['package']['config_dir'] = "/etc/riak-cs"
default['cs']['package']['type'] = "binary"
default['cs']['package']['version']['major'] = "1"
default['cs']['package']['version']['minor'] = "1"
default['cs']['package']['version']['incremental'] = "0"
default['cs']['package']['version']['build'] = "1"
default['cs']['package']['source_checksum'] = '70df2deff15936e4d42c610f641a0c26c46a7a8b1a4db058177e6bfba7d5c8cf'
default['cs']['package']['secret_hash'] = "2fba8f"

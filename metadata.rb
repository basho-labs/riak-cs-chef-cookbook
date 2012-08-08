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


maintainer        "Basho Technologies, Inc."
maintainer_email  "riak@basho.com"
license           "Apache 2.0"
description       "Installs and configures riak cs"
version           "1.0.2"
recipe            "cs", "Installs Riak CS"

%w{ubuntu debian rhel centos}.each do |os|
  supports os
end

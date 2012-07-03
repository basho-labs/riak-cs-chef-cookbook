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

default.cs.lager.handlers.lager_console_backend = :info
default.cs.lager.crash_log = "/var/log/riak-cs/crash.log"
default.cs.lager.crash_log_count = 5
default.cs.lager.crash_log_date = "$D0"
default.cs.lager.crash_log_msg_size = 65536
default.cs.lager.crash_log_size = 10485760
default.cs.lager.error_logger_redirect = true 

#The following two attributes are KEYLESS.
#They hold these values:[NAME,LOG_LEVEL,SIZE,DATE_FORMAT,ROTATION_TO_KEEP]
default.cs.lager.handlers.lager_file_backend.lager_error_log = ["/var/log/riak-cs/error.log", :error, 10485760, "$D0", 5]
default.cs.lager.handlers.lager_file_backend.lager_console_log = ["/var/log/riak-cs/console.log", :info, 10485760, "$D0", 5]
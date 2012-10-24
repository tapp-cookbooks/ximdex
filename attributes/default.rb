#
# Cookbook Name:: bigbluebutton
# Recipe:: default
#
# Copyright 2011, Example Com
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

override['mysql']['bind_address'] = '127.0.0.1'

default['ximdex']['db_user'] = "ximdex"
default['ximdex']['db_passwd'] = "ximdex"
default['ximdex']['database'] = "ximdex"
default['ximdex']['create_database_user'] = 1
default['ximdex']['overwrite_database'] = 1

default['ximdex']['params_host'] = "http://#{node[:fqdn]}"
default['ximdex']['params_path'] = '/var/www'
default['ximdex']['locale'] = "en_US"
default['ximdex']['send_stats'] = 1
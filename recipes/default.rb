#
# Cookbook Name:: mysql_role
# Recipe:: default
#
# Copyright (C) 2014 Fabio Napoleoni
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

=begin
#<
Main recipe used to install and configure MySQL.

Depends on `apt::default` to update the package cache, then it includes all other recipes but `databag_users`
#>
=end

# Force package cache update at compile time
node.set[:apt][:compile_time_update] = true
# Force package cache update
include_recipe 'apt'
# Opscode MySQL recipe for server
include_recipe 'mysql::server'
# Install some utility tools for mysql
include_recipe 'mysql_role::tools'
# Shell configuration
include_recipe 'mysql_role::shell_config'

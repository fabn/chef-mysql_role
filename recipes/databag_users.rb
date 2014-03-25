#
# Cookbook Name:: mysql_role
# Recipe:: databag_users
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

# Json structure used in databag
# {
#    "id": "uniq_id", # not used in recipe but required for databag semantic
#    "server": "db.example.org", // Single or multiple elements allowed
#    "server": ["db1.example.org", "db2.example.org"], // if array the user will be created on all matching servers
#    "username": "db_username", // mandatory parameter
#    "password": "db_password", // mandatory, plain or hashed password
#    "host": "%.example.org", // optional, default localhost
#    "privileges": ["SELECT, UPDATE"], // optional, default :all
#    "database_name": "db", // optional, default *, i.e. all databases
#    // if given the previous grants will be given for all of these database and database parameter is ignored
#    "databases": [
#        "db1",
#        "db2",
#        "db3"
#    ]
# }

# Needed to use database commands
include_recipe 'mysql::ruby'

# Uses default mysql credentials to create users
admin_credentials = {
    host: 'localhost',
    username: 'root',
    password: node[:mysql][:server_root_password]
}

# Iterate found users in databag for this host and grant them permissions
search(node[:mysql][:users_databag], "server:#{node[:fqdn]}").each do |user|
  Chef::Log.info("Configuring MySQL user #{user['username']}")
  # User should be created with multiple grants
  if user['databases']
    user['databases'].each do |database|
      mysql_database_user user['username'] do
        connection admin_credentials
        password user['password']
        database_name database
        host user['host']
        privileges user['privileges']
        action :grant
      end
    end
  else
    # Single database or * if database parameter is omitted
    mysql_database_user user['username'] do
      connection admin_credentials
      password user['password']
      database_name user['database_name']
      host user['host']
      privileges user['privileges']
      action :grant
    end
  end
end

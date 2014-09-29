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

=begin
#<
The recipe is used to create MySQL users from databag contents.

Users are fetched from a `search` into `node[:mysql][:users_databag]` with the key `server:#{server_fqdn}`
where `server_fqdn` is computed from `node[:fqdn]`. If cookbook user is using the [hostname](https://github.com/3ofcoins/chef-cookbook-hostname)
cookbook and he has set `node[:set_fqdn]` to change the hostname it will take precedence on `node[:fqdn]` to
avoid issues on first run.

See [databag format](#databag_format_for_users) for details on databag content.
#>
=end

# Needed to use database commands
include_recipe 'mysql-chef_gem'

# Uses default mysql credentials to create users
admin_credentials = {
    host: 'localhost',
    username: 'root',
    password: node[:mysql][:server_root_password]
}

# server fqdn is checked also in node[:set_fqdn] otherwise if hostname recipe/cookbook
# is included and hostname is changed first execution will fail
server_fqdn = node[:set_fqdn] || node[:fqdn]

# Log hostname used for search into databags
Chef::Log.info %Q{Looking for database users registered for host "#{server_fqdn}"}
# Iterate found users in databag for this host and grant them permissions
search(node[:mysql][:users_databag], "server:#{server_fqdn}").each do |user|
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

#
# Cookbook Name:: mysql_role
# Recipe:: shell_config
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
This recipes provides passwordless mysql access for root user. It writes `'/root/.my.cnf'` file (with `0600` permissions)
to allow root user to access mysql from shell without providing password.
#>
=end

# Allow passwordless mysql for root and crontab stuff
file '/root/.my.cnf' do
  content <<-INI
[client]
password=#{node[:mysql][:server_root_password]}
  INI
  owner 'root'
  group 'root'
  mode '0600'
end

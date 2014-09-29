#
# Cookbook Name:: mysql_role
# Recipe:: tools
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
Installs some useful system tools to interact with MySQL installation. Provided tools are:

* [Percona toolkit](http://www.percona.com/software/percona-toolkit)
* [mysqltuner](https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl)
* [tuning-primer](https://launchpad.net/mysql-tuning-primer)
* [slave_status](http://www.day32.com/MySQL/)

Percona toolkit is installed with Ubuntu native package.

The latter three tools are installed from vendored files into `/usr/local/bin` so they are available in `$PATH`.
#>
=end

# Install the percona-toolkit package
package 'percona-toolkit' do
  action :install
end

# Used by tuning-primer
package 'bc' do
  action :install
end

# MySQL tools automatically installed by this recipe
mysql_tools = %w(mysqltuner.pl tuning-primer.sh slave_status.sh)

mysql_tools.each do |tool|
  # Install the tool into /usr/local/bin folder
  cookbook_file tool do
    path "/usr/local/bin/#{File.basename(tool, '.*')}"
    owner 'root'
    group 'root'
    mode '0755'
  end
end

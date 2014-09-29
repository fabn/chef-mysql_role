# Description

[Role wrapper cookbook](http://www.getchef.com/blog/2013/12/03/doing-wrapper-cookbooks-right/) for MySQL.

Install MySQL and configure utility tools such as Percona Toolkit, mysqltuner and other shell tools.

Currently tested with [test-kitchen](https://github.com/test-kitchen/test-kitchen) and Chef 11.10.4.

On Ubuntu/Debian, Opscode's `apt` cookbook is used to ensure the package
cache is updated so Chef can install mysql chef gem.

Full description on [github](https://github.com/fabn/chef-mysql_role)

# Requirements

## Platform:

* Ubuntu (>= 12.04)

## Cookbooks:

* mysql (= 3.0.2)
* database (~> 1.3.12)
* mysql-chef_gem
* apt (>= 2.6.0)

# Attributes

* `node[:mysql][:bind_address]` -  Defaults to `"0.0.0.0"`.
* `node[:mysql][:allow_remote_root]` -  Defaults to `"false"`.
* `node[:mysql][:remove_test_database]` -  Defaults to `"true"`.
* `node[:mysql][:remove_anonymous_users]` -  Defaults to `"true"`.
* `node[:mysql][:tunable][:log_bin]` - Binary log path used for database replication and incremental backups. Defaults to `"/var/log/mysql/mysql-bin.log"`.
* `node[:mysql][:tunable][:innodb_file_per_table]` - Whether innodb tables should be stored one file per table. Defaults to `"true"`.
* `node[:mysql][:users_databag]` - Databag containing MySQL users. Defaults to `"mysql_users"`.

# Recipes

* [mysql_role::databag_users](#mysql_roledatabag_users) - The recipe is used to create MySQL users from databag contents.
* [mysql_role::default](#mysql_roledefault) - Main recipe used to install and configure MySQL.
* [mysql_role::full](#mysql_rolefull) - Used to install and configure MySQL and configure users through databags.
* [mysql_role::shell_config](#mysql_roleshell_config) - This recipes provides passwordless mysql access for root user.
* [mysql_role::tools](#mysql_roletools) - Installs some useful system tools to interact with MySQL installation.

## mysql_role::databag_users

The recipe is used to create MySQL users from databag contents.

Users are fetched from a `search` into `node[:mysql][:users_databag]` with the key `server:#{server_fqdn}`
where `server_fqdn` is computed from `node[:fqdn]`. If cookbook user is using the [hostname](https://github.com/3ofcoins/chef-cookbook-hostname)
cookbook and he has set `node[:set_fqdn]` to change the hostname it will take precedence on `node[:fqdn]` to
avoid issues on first run.

See [databag format](#databag_format_for_users) for details on databag content.

## mysql_role::default

Main recipe used to install and configure MySQL.

Depends on `apt::default` to update the package cache, then it includes all other recipes but `databag_users`

## mysql_role::full

Used to install and configure MySQL and configure users through databags.

Also includes [default recipe](#mysql_roledefault).

## mysql_role::shell_config

This recipes provides passwordless mysql access for root user. It writes `'/root/.my.cnf'` file (with `0600` permissions)
to allow root user to access mysql from shell without providing password.

## mysql_role::tools

Installs some useful system tools to interact with MySQL installation. Provided tools are:

* [Percona toolkit](http://www.percona.com/software/percona-toolkit)
* [mysqltuner](https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl)
* [tuning-primer](https://launchpad.net/mysql-tuning-primer)
* [slave_status](http://www.day32.com/MySQL/)

Percona toolkit is installed with Ubuntu native package.

The latter three tools are installed from vendored files into `/usr/local/bin` so they are available in `$PATH`.

## Databag format for users

This is the JSON structure used in databag for defining users

```json
{
   "id": "uniq_id", # not used in recipe but required for databag semantic
   "server": "db.example.org", // Single or multiple elements allowed
   "server": ["db1.example.org", "db2.example.org"], // if array the user will be created on all matching servers
   "username": "db_username", // mandatory parameter
   "password": "db_password", // mandatory, plain or hashed password
   "host": "%.example.org", // optional, default localhost
   "privileges": ["SELECT, UPDATE"], // optional, default :all
   "database_name": "db", // optional, default *, i.e. all databases
   // if given the previous grants will be given for all of these database and database parameter is ignored
   "databases": [
       "db1",
       "db2",
       "db3"
   ]
}
```

# License and Maintainer

Maintainer:: Fabio Napoleoni (<f.napoleoni@gmail.com>)

License:: Apache 2.0

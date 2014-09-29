# Some overrides for opscode cookbook defaults
default[:mysql][:bind_address] = '0.0.0.0'
default[:mysql][:allow_remote_root] = false
default[:mysql][:remove_test_database] = true
default[:mysql][:remove_anonymous_users] = true
#<> Binary log path used for database replication and incremental backups
default[:mysql][:tunable][:log_bin] = '/var/log/mysql/mysql-bin.log'
# This is true by default but keep it here just to be sure
#<> Whether innodb tables should be stored one file per table
default[:mysql][:tunable][:innodb_file_per_table] = true
#<> Databag containing MySQL users
default[:mysql][:users_databag] = 'mysql_users'

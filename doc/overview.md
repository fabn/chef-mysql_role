[Role wrapper cookbook](http://www.getchef.com/blog/2013/12/03/doing-wrapper-cookbooks-right/) for MySQL.

Install MySQL and configure utility tools such as Percona Toolkit, mysqltuner and other shell tools.

Currently tested with [test-kitchen](https://github.com/test-kitchen/test-kitchen) and Chef 11.10.4.

On Ubuntu/Debian, Opscode's `apt` cookbook is used to ensure the package
cache is updated so Chef can install mysql chef gem.

Full description on [github](https://github.com/fabn/chef-mysql_role)

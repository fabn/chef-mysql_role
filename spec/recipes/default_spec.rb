RSpec.describe 'mysql_role::default' do

  subject do
    ChefSpec::Runner.new(log_level: :fatal) do |node|
      node.set[:mysql][:server_root_password] = 'rootpass'
      node.set[:mysql][:server_debian_password] = 'debpass'
      node.set[:mysql][:server_repl_password] = 'replpass'
    end.converge(described_recipe)
  end

  before do
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return('')
    stub_search('mysql_users', 'server:fauxhai.local').and_return([])
  end

  %w(mysql::server mysql_role::tools mysql_role::shell_config).each do |recipe|

    it "should include recipe #{recipe}" do
      should include_recipe(recipe)
    end

  end

  it { should_not include_recipe 'mysql_role::databag_users' }

end
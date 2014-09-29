RSpec.describe 'mysql_role::shell_config' do


  let(:chef_run) do
    ChefSpec::Runner.new(log_level: :fatal) do |node|
      node.set[:mysql][:server_root_password] = 'rootpass'
      node.set[:mysql][:server_debian_password] = 'debpass'
      node.set[:mysql][:server_repl_password] = 'replpass'
    end.converge(described_recipe)
  end

  it 'should configure passwordless root access' do
    expect(chef_run).to render_file('/root/.my.cnf').with_content('rootpass')
  end

end
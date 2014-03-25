require 'spec_helper'

describe 'mysql_role::databag_users' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:mysql][:server_root_password] = 'rootpass'
      node.set[:mysql][:server_debian_password] = 'debpass'
      node.set[:mysql][:server_repl_password] = 'replpass'
    end.converge(described_recipe)
  end

  before do
    stub_search('mysql_users', 'server:fauxhai.local').and_return([])
  end

  it 'should install chef gem mysql' do
    expect(chef_run).to include_recipe 'mysql::ruby'
  end

end

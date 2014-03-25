require 'spec_helper'

describe 'mysql_role::tools' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:mysql][:server_root_password] = 'rootpass'
      node.set[:mysql][:server_debian_password] = 'debpass'
      node.set[:mysql][:server_repl_password] = 'replpass'
    end.converge(described_recipe)
  end

  it 'should install utility packages' do
    expect(chef_run).to install_package('percona-toolkit')
  end

  %w(mysqltuner.pl tuning-primer.sh slave_status.sh).each do |tool|
    it "should install #{tool} tool into /usr/local/bin" do
      tool_binary = File.basename(tool, '.*')
      expect(chef_run).to create_remote_file("/usr/local/bin/#{tool_binary}")
    end
  end

end
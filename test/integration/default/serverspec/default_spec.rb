require 'spec_helper'

describe 'MySQL Installation' do

  describe service('mysql') do
    it { should be_running }
    it { should be_enabled }
  end

  context 'Additional tools' do
    describe package('percona-toolkit') do
      it { should be_installed }
    end

    %w(mysqltuner tuning-primer slave_status).each do |tool|

      describe command("which #{tool}") do
        it { should return_exit_status(0) }
        it { should return_stdout %r{/usr/local/bin} }
      end

    end
  end

  context 'Shell configuration' do
    # Passwordless mysql for root when HOME is set
    describe command('HOME=/root mysql -e "SHOW DATABASES"') do
      it { should return_exit_status(0) }
      it { should return_stdout /mysql/ }
    end

  end

  context 'Remote root access' do

    # 10.0.2.15 is vagrant local address
    describe command('HOME=/root mysql -h 10.0.2.15 -e "SHOW DATABASES"') do
      it { should_not return_exit_status(0) }
    end

    describe command(%q{HOME=/root mysql -e "SELECT User, Host FROM user WHERE User = 'root';" mysql}) do
      it { should_not return_stdout /%/ }
    end

  end

  context 'Binlog configuration' do

    describe file('/var/log/mysql/mysql-bin.index') do
      it { should be_file }
      it { should be_owned_by('mysql') }
    end

  end

end

require 'spec_helper'

describe 'MySQL users creation through database' do

  # See databags for created users

  describe command('HOME=/root mysql -e "SHOW GRANTS FOR user1"') do

    it { should return_stdout %r{GRANT USAGE ON \*\.\* TO 'user1'@'%' IDENTIFIED BY PASSWORD '\*14E65567ABDB5135D0CFD9A70B3032C179A49EE7'} }
    it { should return_stdout %r{GRANT SELECT, INSERT, UPDATE, DELETE ON `database_1`\.\* TO 'user1'@'%'} }
    it { should return_stdout %r{GRANT SELECT, INSERT, UPDATE, DELETE ON `database_2`.* TO 'user1'@'%'} }

  end

  describe command('HOME=/root mysql -e "SHOW GRANTS FOR user2"') do

    it { should return_stdout %r{GRANT USAGE ON \*\.\* TO 'user2'@'%' IDENTIFIED BY PASSWORD '\*14E65567ABDB5135D0CFD9A70B3032C179A49EE7'} }
    it { should return_stdout %r{GRANT SELECT, INSERT, UPDATE, DELETE ON `database_3`\.\* TO 'user2'@'%'} }

  end

end

require 'rbconfig'
require 'fileutils'

# ruby executable
ruby = File.join(RbConfig::CONFIG["bindir"],
            RbConfig::CONFIG["RUBY_INSTALL_NAME"]+
            RbConfig::CONFIG["EXEEXT"])

arguments = "-I '#{File.expand_path('../../lib', __FILE__)}'"
skm = "'#{File.expand_path('../../bin/skm', __FILE__)}'"
skm_dir = "#{ENV['HOME']}/.skm-test"

cmd_prefix = "#{ruby} #{arguments} #{skm} --skm-dir '#{skm_dir}'"

KEYS_DIR = "#{skm_dir}/keys"
SSH_DIR = "#{ENV['HOME']}/.ssh"

describe 'skm' do

  before(:all) do
    FileUtils.rm_rf skm_dir
    FileUtils.mv SSH_DIR, "#{SSH_DIR}.bak" if File.exists? SSH_DIR
  end

  after(:all) do
    FileUtils.rm_rf skm_dir  # remove the test dir
    FileUtils.rm_rf SSH_DIR
    FileUtils.mv "#{SSH_DIR}.bak", SSH_DIR if File.exists? "#{SSH_DIR}.bak"
  end

  describe '#Create command' do
    it 'should put new keys in ~/.skm/keys' do
      system "#{cmd_prefix} create test_create --no-password"

      File.exists?("#{KEYS_DIR}/test_create/id_rsa").should == true
      File.exists?("#{KEYS_DIR}/test_create/id_rsa.pub").should == true
    end

    it 'should do the same for dsa algorithm' do
      system "#{cmd_prefix} create test_create_dsa --no-password --type dsa"

      File.exists?("#{KEYS_DIR}/test_create_dsa/id_dsa").should == true
      File.exists?("#{KEYS_DIR}/test_create_dsa/id_dsa.pub").should == true
    end
  end

  describe '#Use command' do
    it 'should copy keys to ~/.ssh directory' do

      FileUtils.rm_rf "#{SSH_DIR}"    # test for the case SSH_DIR doesn't exist

      system "#{cmd_prefix} create test_use0 --no-password"
      system "#{cmd_prefix} create test_use1 --no-password"

      system "#{cmd_prefix} use test_use0"
      FileUtils.compare_file("#{SSH_DIR}/id_rsa", "#{KEYS_DIR}/test_use0/id_rsa").should == true
      FileUtils.compare_file("#{SSH_DIR}/id_rsa.pub", "#{KEYS_DIR}/test_use0/id_rsa.pub").should == true

      system "#{cmd_prefix} use test_use1"
      FileUtils.compare_file("#{SSH_DIR}/id_rsa", "#{KEYS_DIR}/test_use1/id_rsa").should == true
      FileUtils.compare_file("#{SSH_DIR}/id_rsa.pub", "#{KEYS_DIR}/test_use1/id_rsa.pub").should == true
    end

    it 'should do the same for dsa algorithm' do

      FileUtils.rm_rf "#{SSH_DIR}"    # test for the case SSH_DIR doesn't exist

      system "#{cmd_prefix} create test_use_dsa0 --no-password --type dsa"
      system "#{cmd_prefix} create test_use_dsa1 --no-password --type dsa"

      system "#{cmd_prefix} use test_use_dsa0"
      FileUtils.compare_file("#{SSH_DIR}/id_dsa", "#{KEYS_DIR}/test_use_dsa0/id_dsa").should == true
      FileUtils.compare_file("#{SSH_DIR}/id_dsa.pub", "#{KEYS_DIR}/test_use_dsa0/id_dsa.pub").should == true

      system "#{cmd_prefix} use test_use_dsa1"
      FileUtils.compare_file("#{SSH_DIR}/id_dsa", "#{KEYS_DIR}/test_use_dsa1/id_dsa").should == true
      FileUtils.compare_file("#{SSH_DIR}/id_dsa.pub", "#{KEYS_DIR}/test_use_dsa1/id_dsa.pub").should == true
    end
  end

  describe '#List command' do
    it 'should list all existing keys' do
      FileUtils.rm_rf KEYS_DIR  # remove all keys first

      system "#{cmd_prefix} create test_list1 --no-password"
      system "#{cmd_prefix} create test_list2 --no-password --type dsa"

      lines = `#{cmd_prefix} list`.split(/\n/)
      lines.include?('  test_list1').should == true
      lines.include?('  test_list2').should == true
      lines.length.should == 2

      system "#{cmd_prefix} use test_list1"

      lines = `#{cmd_prefix} list`.split(/\n/)
      lines.include?('* test_list1').should == true
      lines.include?('  test_list2').should == true
      lines.length.should == 2
    end
  end

  describe '#Show command' do
    it 'should show the public key' do
      FileUtils.rm_rf KEYS_DIR  # remove all keys first
      system "#{cmd_prefix} create test_show1 --no-password"
      system "#{cmd_prefix} create test_show2 --no-password --type dsa"

      system("#{cmd_prefix} show test_show1").should == true
      system("#{cmd_prefix} show test_show2").should == true
      system("#{cmd_prefix} show non_existence").should == false
    end
  end

  describe '#Non-existing command' do
    it 'should be unsuccessful' do
      system("#{cmd_prefix} I_am_a_non_existing_command").should == false
    end
  end
end

# vim: ts=2 sw=2 et

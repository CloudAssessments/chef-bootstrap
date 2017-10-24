# # encoding: utf-8

# Inspec test for recipe bootstrap::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root') do
    it { should exist }
  end

  describe user('cloud_user') do
    it { should exist }
  end
end

describe file('/etc/ssh/sshd_config') do
  its(:content) { should contain 'PasswordAuthentication yes' }
end

describe file('/usr/bin/aws') do
  it { should exist }
end

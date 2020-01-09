require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'rsyslog class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'rsyslog':
        filecreatemode => '0640',
        modules => [ 'imudp' ],
      }

      rsyslog::imudp { 'default_listen':
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file('/etc/rsyslog.conf') do
      it { should be_file }
      its(:content) { should match '\$FileCreateMode 0640' }
    end

    describe file('/etc/rsyslog.d/00-modules.conf') do
      it { should be_file }
      its(:content) { should match '\$ModLoad imudp' }
    end

    describe file('/etc/rsyslog.d/01-imudp-default_listen.conf') do
      it { should be_file }
      its(:content) { should match '\$UDPServerRun 514' }
    end

    describe service('rsyslog') do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe package('rsyslog') do
      it { is_expected.to be_installed }
    end

    describe port(514) do
      it { should be_listening.with('udp') }
    end

  end
end

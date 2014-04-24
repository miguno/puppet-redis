require 'spec_helper'

describe 'redis' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        default_configuration_file  = '/etc/redis/redis.conf'

        describe "redis with default settings on #{osfamily}" do
          let(:params) {{ }}
          # We must mock $::operatingsystem because otherwise this test will
          # fail when you run the tests on e.g. Mac OS X.
          it { should compile.with_all_deps }

          it { should contain_class('redis::params') }
          it { should contain_class('redis') }
          it { should contain_class('redis::users').that_comes_before('redis::install') }
          it { should contain_class('redis::install').that_comes_before('redis::config') }
          it { should contain_class('redis::config') }
          it { should contain_class('redis::service').that_subscribes_to('redis::config') }

          it { should contain_package('redis').with_ensure('present') }

          it { should contain_group('redis').with({
            'ensure'     => 'present',
            'gid'        => 53003,
          })}

          it { should contain_user('redis').with({
            'ensure'     => 'present',
            'home'       => '/home/redis',
            'shell'      => '/bin/bash',
            'uid'        => 53003,
            'comment'    => 'Redis system account',
            'gid'        => 'redis',
            'managehome' => true,
          })}

          it { should contain_file('/app/redis').with({
            'ensure' => 'directory',
            'owner'  => 'redis',
            'group'  => 'redis',
            'mode'   => '0750',
          })}

          it { should contain_file(default_configuration_file).with({
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            }).
            with_content(/^port 6379$/).
            with_content(/^dir \/app\/redis$/)
          }

          it { should contain_supervisor__service('redis').with({
            'ensure'      => 'present',
            'enable'      => true,
            'command'     => 'redis-server /etc/redis/redis.conf',
            'directory'   => '/',
            'user'        => 'redis',
            'group'       => 'redis',
            'autorestart' => true,
            'startsecs'   => 10,
            'retries'     => 999,
            'stdout_logfile_maxsize' => '20MB',
            'stdout_logfile_keep'    => 5,
            'stderr_logfile_maxsize' => '20MB',
            'stderr_logfile_keep'    => 10,
          })}
        end

        describe "redis with disabled user management on #{osfamily}" do
          let(:params) {{
            :user_manage  => false,
          }}
          it { should_not contain_group('redis') }
          it { should_not contain_user('redis') }
        end

        describe "redis with custom user and group on #{osfamily}" do
          let(:params) {{
            :user_manage      => true,
            :gid              => 456,
            :group            => 'redisgroup',
            :uid              => 123,
            :user             => 'redisuser',
            :user_description => 'Redis user',
            :user_home        => '/home/redisuser',
          }}

          it { should_not contain_group('redis') }
          it { should_not contain_user('redis') }

          it { should contain_user('redisuser').with({
            'ensure'     => 'present',
            'home'       => '/home/redisuser',
            'shell'      => '/bin/bash',
            'uid'        => 123,
            'comment'    => 'Redis user',
            'gid'        => 'redisgroup',
            'managehome' => true,
          })}

          it { should contain_group('redisgroup').with({
            'ensure'     => 'present',
            'gid'        => 456,
          })}
        end

        describe "redis with a custom port on #{osfamily}" do
          let(:params) {{
            :port => 6666,
          }}

          it { should contain_file(default_configuration_file).with_content(/^port 6666$/) }
        end

        describe "redis with a custom working directory on #{osfamily}" do
          let(:params) {{
            :working_dir => '/tmp/foo/bar',
          }}

          it { should contain_file(default_configuration_file).with_content(/^dir \/tmp\/foo\/bar$/) }
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'redis without any parameters on Debian' do
      let(:facts) {{
        :osfamily => 'Debian',
      }}

      it { expect { should contain_class('redis') }.to raise_error(Puppet::Error,
        /The redis module is not supported on a Debian based system./) }
    end
  end
end

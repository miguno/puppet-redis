# == Class redis::params
#
class redis::params {
  $command             = 'redis-server'
  $config              = '/etc/redis/redis.conf'
  $config_template     = 'redis/redis.conf.erb'
  $gid                 = 53003
  $group               = 'redis'
  $group_ensure        = 'present'
  $package_name        = 'redis'
  $package_ensure      = 'present'
  $port                = 6379
  $service_autorestart = true
  $service_enable      = true
  $service_ensure      = 'present'
  $service_manage      = true
  $service_name        = 'redis'
  $service_retries     = 999
  $service_startsecs   = 10
  $service_stderr_logfile_keep    = 10
  $service_stderr_logfile_maxsize = '20MB'
  $service_stdout_logfile_keep    = 5
  $service_stdout_logfile_maxsize = '20MB'
  $shell               = '/bin/bash'
  $uid                 = 53003
  $user                = 'redis'
  $user_description    = 'Redis system account'
  $user_ensure         = 'present'
  $user_home           = '/home/redis'
  $user_manage         = true
  $user_managehome     = true
  $working_dir         = '/app/redis'

  case $::osfamily {
    'RedHat': {}

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}

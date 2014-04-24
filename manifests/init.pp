# == Class redis
#
# === Parameters
#
# TODO: Document each class parameter.
#
class redis (
  $command             = $redis::params::command,
  $config              = $redis::params::config,
  $config_template     = $redis::params::config_template,
  $gid                 = $redis::params::gid,
  $group               = $redis::params::group,
  $group_ensure        = $redis::params::group_ensure,
  $package_name        = $redis::params::package_name,
  $package_ensure      = $redis::params::package_ensure,
  $port                = $redis::params::port,
  $service_autorestart = hiera('redis::service_autorestart', $redis::params::service_autorestart),
  $service_enable      = hiera('redis::service_enable', $redis::params::service_enable),
  $service_ensure      = $redis::params::service_ensure,
  $service_manage      = hiera('redis::service_manage', $redis::params::service_manage),
  $service_name        = $redis::params::service_name,
  $service_retries     = $redis::params::service_retries,
  $service_startsecs   = $redis::params::service_startsecs,
  $service_stderr_logfile_keep    = $redis::params::service_stderr_logfile_keep,
  $service_stderr_logfile_maxsize = $redis::params::service_stderr_logfile_maxsize,
  $service_stdout_logfile_keep    = $redis::params::service_stdout_logfile_keep,
  $service_stdout_logfile_maxsize = $redis::params::service_stdout_logfile_maxsize,
  $shell               = $redis::params::shell,
  $uid                 = $redis::params::uid,
  $user                = $redis::params::user,
  $user_description    = $redis::params::user_description,
  $user_ensure         = $redis::params::user_ensure,
  $user_home           = $redis::params::user_home,
  $user_manage         = hiera('redis::user_manage', $redis::params::user_manage),
  $user_managehome     = hiera('redis::user_managehome', $redis::params::user_managehome),
  $working_dir         = $redis::params::working_dir,
) inherits redis::params {

  validate_string($command)
  validate_absolute_path($config)
  validate_string($config_template)
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_string($group)
  validate_string($group_ensure)
  validate_string($package_name)
  validate_string($package_ensure)
  if !is_integer($port) { fail('The $port parameter must be an integer number') }
  validate_bool($service_autorestart)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  if !is_integer($service_retries) { fail('The $service_retries parameter must be an integer number') }
  if !is_integer($service_startsecs) { fail('The $service_startsecs parameter must be an integer number') }
  if !is_integer($service_stderr_logfile_keep) {
    fail('The $service_stderr_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stderr_logfile_maxsize)
  if !is_integer($service_stdout_logfile_keep) {
    fail('The $service_stdout_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stdout_logfile_maxsize)
  validate_absolute_path($shell)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_manage)
  validate_bool($user_managehome)
  validate_absolute_path($working_dir)

  include '::redis::users'
  include '::redis::install'
  include '::redis::config'
  include '::redis::service'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'redis::begin': }
  anchor { 'redis::end': }

  Anchor['redis::begin']
  -> Class['::redis::users']
  -> Class['::redis::install']
  -> Class['::redis::config']
  ~> Class['::redis::service']
  -> Anchor['redis::end']
}

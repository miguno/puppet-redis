# == Class redis::install
#
class redis::install inherits redis {

  package { 'redis':
    ensure  => $package_ensure,
    name    => $package_name,
  }

  # This exec ensures we create intermediate directories for $working_dir as required
  exec { 'create-redis-working-directory':
    command => "mkdir -p ${working_dir}",
    path    => ['/bin', '/sbin'],
    require => Package['redis'],
  }
  ->
  file { $working_dir:
    ensure       => directory,
    owner        => $user,
    group        => $group,
    mode         => '0750',
    recurse      => true,
    recurselimit => 0,
  }

}

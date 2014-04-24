# == Class redis::config
#
class redis::config inherits redis {

  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($config_template),
    require => Class['redis::install'],
  }

}

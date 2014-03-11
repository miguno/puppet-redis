class redis::install inherits redis {

  group { $group:
    ensure => $group_ensure,
    gid    => $gid,
  }

  user { $user:
    ensure     => $user_ensure,
    home       => $user_home,
    shell      => $shell,
    uid        => $uid,
    comment    => $user_description,
    gid        => $group,
    managehome => $user_managehome,
    require    => Group[$group],
  }

  file { $working_dir:
    ensure       => directory,
    owner        => $user,
    group        => $group,
    mode         => '0750',
    recurse      => true,
    recurselimit => 0,
  }

  package { 'redis':
    ensure  => $package_ensure,
    name    => $package_name,
  }

}

# == Class: redis::service
#
# This class exists to coordinate all service management related actions,
# functionality and logical units in a central place.
#
class redis::service inherits redis {

  if !($service_ensure in ['present', 'absent']) {
    fail('service_ensure parameter must be "present" or "absent"')
  }

  if $service_manage == true {
    supervisor::service {
      $service_name:
        ensure                 => $service_ensure,
        enable                 => $service_enable,
        command                => "${command} ${config}",
        directory              => '/',
        user                   => $user,
        group                  => $group,
        autorestart            => $service_autorestart,
        startsecs              => $service_startsecs,
        retries                => $service_retries,
        stdout_logfile_maxsize => $service_stdout_logfile_maxsize,
        stdout_logfile_keep    => $service_stdout_logfile_keep,
        stderr_logfile_maxsize => $service_stderr_logfile_maxsize,
        stderr_logfile_keep    => $service_stderr_logfile_keep,
        require                => [ Class['redis::install'], Class['redis::config'], Class['::supervisor'] ],
    }

    if $service_enable == true {
      exec { 'restart-redis':
        command     => "supervisorctl restart ${service_name}",
        path        => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
        user        => 'root',
        refreshonly => true,
        subscribe   => File[$config],
        onlyif      => 'which supervisorctl &>/dev/null',
        require     => Class['::supervisor'],
      }
    }

  }

}

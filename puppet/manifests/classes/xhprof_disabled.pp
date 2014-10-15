class xhprof_disabled {
  file { '/etc/php5/apache2/conf.d/xhprof.ini':
    ensure  => 'absent',
    notify => Class['apache::service'],
  }

  file { '/etc/apache2/sites-enabled/xhprof.conf':
    ensure => 'absent',
    notify => Class['apache::service'],
  }
}

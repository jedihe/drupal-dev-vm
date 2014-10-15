class xdebug_disabled {
  file { '/etc/php5/conf.d/xdebug.ini':
    ensure => 'absent',
    notify => Class['apache::service'],
  }
}

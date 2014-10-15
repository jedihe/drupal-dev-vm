class xdebug_disabled {
  file { '/etc/php5/conf.d/xdebug.ini':
    ensure => 'purged',
    notify => Class['apache::service'],
  }
}

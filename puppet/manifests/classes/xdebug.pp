class xdebug {
  package { php5-xdebug:
    ensure => installed,
    require => Package['php5']
  }

  file { '/etc/php5/conf.d/xdebug.ini':
    ensure => 'present',
    content => "zend_extension=/usr/lib/php5/20090626/xdebug.so
xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000",
    mode   => 644,
    require => Package['php5-xdebug'],
  }
}

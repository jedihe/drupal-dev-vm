class devel {

  package { ['screen', 'mailutils']:
    ensure => installed,
  }

  package { php5-xdebug:
    ensure => installed,
    require => Package['php5']
  }

  file { '/etc/php5/conf.d/xdebug.ini':
    ensure => 'present',
    content => "zend_extension=/usr/lib/php5/20090626+lfs/xdebug.so
xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000",
    mode   => 644,
    require => Package['php5-xdebug'],
  }

  curl::fetch_and_command { "composer-install":
    source      => "https://getcomposer.org/installer",
    destination => "/tmp/composer-installer.php",
    timeout     => 30,
    command => "php composer-installer.php && mv composer.phar /usr/local/bin/composer",
    command_cwd => "/tmp",
    command_unless => 'test -x /usr/local/bin/composer',
    verbose     => false,
  }
}

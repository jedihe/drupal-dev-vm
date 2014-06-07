class apache_php {
  include mysql

  class {'apache':
    user => 'vagrant',
    group => 'www-data',
  }

  class {'apache::mod::php':
    require => Package["php5"]
  }

  apache::mod{'rewrite': }
  apache::mod{'proxy_http': }

  package { php5:
    ensure => installed,
  }
  package { ['php5-mysql', 'php5-imap', 'php5-gd', 'php5-dev', 'php-pear', 'php5-curl', 'php5-cli', 'php5-common']:
    ensure => installed,
    require => Package["php5"]
  }

  #pecl install uploadprogress
  #exec { 'pecl install uploadprogress':
  #  command => "/usr/bin/pear config-set http_proxy ${http_proxy} && /usr/bin/pecl install uploadprogress",
  #  require => Package['php-pear'],
  #  creates => '/usr/lib/php5/20090626/uploadprogress.so'
  #}

  #file { '/etc/php5/apache2/conf.d/uploadprogress.ini':
  #  ensure   => "present",
  #  content => "extension=uploadprogress.so\n",
  #  mode     => 644,
  #  require => Class['apache::mod::php'],
  #}

  augeas { 'php_dev_config':
    context => '/files/etc/php5/apache2/php.ini/PHP',
    changes => [
      'set memory_limit 1024M',
      'set max_execution_time 1800',
      'set max_input_time 90',
      'set error_reporting E_ALL | E_STRICT',
      'set display_errors On',
      'set display_startup_errors On',
      'set html_errors On',
      'set error_prepend_string <pre>',
      'set error_apend_string </pre>',
      'set post_max_size 34M',
      'set upload_max_filesize 32M',
    ],
    require => Package['php5'],
    notify => Class['apache::service'],
  }
}

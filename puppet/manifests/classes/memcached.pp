class memcached {
  package { memcached:
    ensure => installed,
    require => Package["php5"]
  }

  package { libmemcached-dev:
    ensure => installed,
    require => Package['memcached']
  }

  exec { 'pecl-memcached-2.0.1':
    command => 'sudo pecl install -f memcached-2.0.1',
    require => Package['libmemcached-dev'],
    creates => '/usr/lib/php5/20090626+lfs/memcached.so',
    path => ['/usr/bin'],
  }

  exec { 'start-memcached':
    command => 'sudo service memcached start',
    path => ['/usr/bin'],
  }

  file { '/etc/php5/apache2/conf.d/memcached.ini':
    ensure  => 'present',
    content => 'extension=memcached.so',
    mode    =>  644,
    require => [
      Class['apache::mod::php'],
      Exec['pecl-memcached-2.0.1']
    ],
    notify => Class['apache::service'],
  }
}

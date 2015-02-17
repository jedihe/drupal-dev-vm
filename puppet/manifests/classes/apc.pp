class apc {
  package { 'php-apc':
    ensure => installed,
    require => Package["php5"]
  }

  file { '/etc/php5/conf.d/apc.ini':
    ensure => "present",
    content => "apc.shm_size=\"196M\"
;extension=apc.so",
    require => Package['php-apc'],
  }
}

class phpmyadmin {
  package { phpmyadmin:
    ensure => installed,
    require => Package['php5', 'mysql-server'],
  }

  # Add phpmyadmin to Apache
  file { '/etc/apache2/sites-enabled/phpmyadmin.conf':
    ensure => 'present',
    content => 'include /etc/phpmyadmin/apache.conf',
    mode => 644,
    replace => true,
    require => [
      Class['apache::mod::php'],
      Package['phpmyadmin']
    ],
    notify => Class['apache::service'],
  }

  # Use the autologin config (THIS IS ONLY MEANT FOR LOCAL DEV ENVS!)
  file { '/etc/phpmyadmin/config.inc.php':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/import-sites/pma-autologin-config.inc.php',
    replace => true,
    require => Package['phpmyadmin'],
  }
}

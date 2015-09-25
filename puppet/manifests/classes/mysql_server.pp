class mysql_server {
  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'root' },
    enabled => 'true',
  }

  file { '/etc/service/mysql':
    ensure => "directory",
    require => [
      Package['mysql-server'],
    ],
  }

  file { '/etc/service/mysql/run':
    ensure => present,
    source => "/vagrant/docker/mysql.sh",
    mode => 755,
    require => File['/etc/service/mysql'],
  }

  file { '/etc/my_init.d/99_mysql_setup.sh':
    ensure => present,
    source => "/vagrant/docker/99_mysql_setup.sh",
    mode => 755,
    require => [
      File['/etc/service/mysql/run'],
    ],
  }
}

class mysql_server {
  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'root' },
    enabled => 'true',
  }

  file { '/etc/service/mysql':
    ensure => "directory",
    #mode => 755,
    #owner => "vagrant",
    #group => "vagrant",
    #recurse => true,
    require => [
      Class['mysql::server']
    ],
  }

  file { '/etc/service/mysql/run':
    ensure => present,
    source => "/vagrant/mysql.sh",
    mode => 755,
    require => File['/etc/service/mysql'],
  }

  file { '/etc/my_init.d/99_mysql_setup.sh':
    ensure => present,
    source => "/vagrant/99_mysql_setup.sh",
    mode => 755,
    require => [
      Class['mysql::server'],
      File['/etc/service/mysql/run'],
    ],
  }
}

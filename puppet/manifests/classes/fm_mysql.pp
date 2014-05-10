class fm_mysql {
  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'root' },
  }
}

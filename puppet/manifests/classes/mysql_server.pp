class mysql_server {
  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'root' },
  }
}

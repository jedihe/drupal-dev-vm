node "default" {
  include linux_common
  include drupal
  include devel
  include git
  include vim
  include phpmyadmin
  include memcached
  include apc
  include runkit
  include import_sites
  include php_testing
  include xhprof
  include xdebug

  # Uncomment to install Unity desktop environment
  #include de_unity

  add_user {"vagrant":
    email => 'none@vagrant.com',
    uid => 5001,
    password => 'vagrant',
  }
}


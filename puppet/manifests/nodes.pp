# vi:syntax=ruby
# vi: set ft=ruby :

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
  #include xhprof_enabled
  include xhprof_disabled
  #include xdebug_enabled
  include xdebug_disabled

  # Uncomment to install Unity desktop environment
  #include de_unity

  add_user {"vagrant":
    email => 'vagrant@localhost',
    uid => $::host_uid,
    password => 'vagrant',
    sudoer => true,
  }
}


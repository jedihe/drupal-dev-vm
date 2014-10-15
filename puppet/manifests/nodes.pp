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
    email => 'none@vagrant.com',
    uid => 5001,
    password => 'vagrant',
  }

  # Add insecure_key.pub for vagrant user
  file { '/home/vagrant/.ssh/authorized_keys':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => '0600',
    source  => '/vagrant/insecure_key.pub',
    replace => true,
    require => Add_user['vagrant'],
  }
}


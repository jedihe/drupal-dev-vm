class drupal {
  include mysql_server
  include apache_php
  include compass

  exec { 'install drush':
    command => "/usr/local/bin/composer global require drush/drush:7.0.0-alpha8",
    require => Curl::Fetch_and_command['composer-install'],
    path => ['/usr/bin', '/usr/local/bin'],
    user => 'vagrant',
    creates => '/home/vagrant/.composer/vendor/bin/drush',
    timeout => 300,
  }

  file { '/home/vagrant/.drush':
    ensure => 'directory',
    owner => 'vagrant',
    group => 'vagrant',
    mode => 644,
  }

  exec { "install drush-quickstart":
    command => 'git clone http://git.drupal.org/project/quickstart.git',
    cwd => '/home/vagrant/.drush',
    user => 'vagrant',
    creates => '/home/vagrant/.drush/quickstart',
    path => ['/bin', '/usr/bin', '/usr/sbin'],
    require => [File['/home/vagrant/.drush'], Package['git']],
  }

  exec { "patch drush-quickstart":
    command => 'git checkout e5541eb4fc6ecac4de42b40156125aacff9ce01a &&
patch -p1 < /vagrant/patches/quickstart-adjustments.patch &&
echo "Quickstart was patched successfully!" > /home/vagrant/.drush/quickstart.lock',
    cwd => '/home/vagrant/.drush/quickstart',
    user => 'vagrant',
    creates => '/home/vagrant/.drush/quickstart.lock',
    path => ['/bin', '/usr/bin', '/usr/sbin'],
    require => [Exec['install drush-quickstart']],
  }

  # create the main web directory parent
  file { "/var/www":
    ensure => "directory",
    owner => 'vagrant',
    group => 'www-data',
  }

  # setup the crontab
  # TODO: the path for drush may be different on lucid
  cron { drupal:
    command => "/usr/bin/drush -r ${fqdn} cron >/dev/null",
    user    => www-data,
    minute  => 0,
    require => Exec['install drush'],
  }

  # update /etc/hosts file
  host { '/etc/hosts clean':
    ip => '127.0.1.1',
    name => $hostname,
    ensure => absent
  }

  # set the aliased virtual host to the first network interface. vagrant sets this
  # If you need this externally accessible ensure you have a working setup on
  # eth1 (via bridged networking and change ip to $ipaddress_eth1)
  host { '/etc/hosts drupal':
    ip => $ipaddress_eth0,
    ensure => present,
    name => $fqdn,
    host_aliases => ["www.${fqdn}", $hostname],
  }
}

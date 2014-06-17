class drupal {
  include mysql_server
  include apache_php
  include compass

  package { 'php-console-table':
    ensure => installed,
    require => Package['php-pear']
  }

  # install drush, we use this method over the ubuntu package as that requires
  # a drush self-update that prompts for a version. This method uses drush's
  # official pear channel.
  exec { 'install drush':
    command => "${pear_proxy_prefix}pear channel-discover pear.drush.org && pear install drush/drush-5.9.0",
    require => Package['php-console-table'],
    path => ['/usr/bin'],
    creates => '/usr/bin/drush'
  }

  file { '/home/vagrant/.drush':
    ensure => 'directory',
    owner => 'vagrant',
    group => 'vagrant',
    mode => 644,
  }

  exec { "install quickstart commands":
    command => 'sudo git clone http://git.drupal.org/project/quickstart.git',
    cwd => '/home/vagrant/.drush',
    user => 'vagrant',
    unless => 'ls /home/vagrant/.drush/quickstart',
    path => ['/bin', '/usr/bin', '/usr/sbin'],
    require => [File['/home/vagrant/.drush'], Package['git']],
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

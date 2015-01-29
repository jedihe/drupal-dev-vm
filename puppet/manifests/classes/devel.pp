class devel {

  package { ['screen', 'mailutils']:
    ensure => installed,
  }

  exec { 'phpcs':
    command => 'pear install PHP_CodeSniffer-1.5.6',
    unless => 'test -x /usr/bin/phpcs',
    path => ['/bin', '/usr/bin'],
    require => Package['php-pear'],
  }

  exec { 'drupal-coder-install':
    command => 'drush pm-download coder --destination=/home/vagrant/.drush',
    unless => 'test -d /home/vagrant/.drush/coder',
    path => ['/bin', '/usr/bin'],
    require => [Exec['install drush']],
  }

  curl::fetch_and_command { "composer-install":
    source      => "https://getcomposer.org/installer",
    destination => "/tmp/composer-installer.php",
    timeout     => 30,
    command => "php composer-installer.php && mv composer.phar /usr/local/bin/composer",
    command_cwd => "/tmp",
    command_unless => 'test -x /usr/local/bin/composer',
    verbose     => false,
  }
}

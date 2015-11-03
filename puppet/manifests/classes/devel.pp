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

  package { 'lua5.2': ensure => installed }

  # ==================================================
  # Web Dev
  # ==================================================
  ppa_package { "node js":
    ppa => 'ppa:chris-lea/node.js',
    package => 'nodejs',
  }

  exec { 'grunt cli':
    command => 'npm install -g grunt-cli',
    unless => 'ls /usr/bin/grunt',
    path => ['/bin', '/usr/bin'],
    logoutput => true,
    require => Ppa_package['node js'],
  }

  exec { 'bower cli':
    command => 'npm install -g bower',
    unless => 'ls /usr/bin/bower',
    path => ['/bin', '/usr/bin'],
    logoutput => true,
    require => Ppa_package['node js'],
  }

  # Terminus (Pantheon CLI)
  curl::fetch_and_command { "terminus-install":
    source      => "https://github.com/pantheon-systems/cli/releases/download/0.9.2/terminus.phar",
    destination => "/usr/local/bin/terminus",
    timeout     => 60,
    command => "chmod +x /usr/local/bin/terminus",
    command_cwd => "/usr/local/bin",
    command_unless => 'test -x /usr/local/bin/terminus',
    verbose     => false,
  }

}

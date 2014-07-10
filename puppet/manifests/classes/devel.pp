class devel {

  package { ['screen', 'mailutils']:
    ensure => installed,
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

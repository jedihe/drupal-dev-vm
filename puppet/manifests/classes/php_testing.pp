class php_testing {
  #exec { 'install phpunit':
    #command => "${pear_proxy_prefix}pear channel-discover pear.phpunit.de && pear install phpunit/PHPUnit-3.6.12",
    #require => Package['php5'],
    #path => ['/usr/bin'],
    #creates => '/usr/bin/drush'
  #}

  curl::fetch_and_command { "phpunit-install":
    source      => "https://phar.phpunit.de/phpunit-lts.phar",
    destination => "/usr/local/bin/phpunit",
    timeout     => 30,
    command => "chmod +x phpunit",
    command_cwd => "/usr/local/bin",
    command_unless => 'test -x /usr/local/bin/phpunit',
    verbose     => false,
  }
}

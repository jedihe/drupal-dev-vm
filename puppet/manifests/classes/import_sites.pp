class import_sites {
  $proxy_pass = [
    { 'path' => '/proxied/path','url' => "http://acme.com/proxied/path" },
  ]

  # Main domain, used for accessing apc.php
  # Remember to set the hosts file (host OS) to point correctly to this
  # hosts file must have: 127.0.0.1  local.acme.com
  drupal_site { 'local.acme.com':
    domain => 'local.acme.com',
    docroot => '/var/www',
    add_vhost => true,
    proxy_pass => $proxy_pass,
    port => 8080,
  }

  # Manually copy apc.php
  file { "apc.php":
    path => "/var/www/apc.php",
    source => "/vagrant/import-sites/apc.php",
    mode => 644,
    replace => true,
    ensure => present,
    owner => "vagrant",
    group => "vagrant",
    require => Drupal_site['local.acme.com'],
  }

  # Example site
  # Accessible via http://local.acme.com:8181 or http://local.acme.com:8080/drupal
  # (as long as host OS has proper settings in hosts file)
  #drupal_site { 'drupal.local':
    #domain => 'drupal.local',
    #docroot => '/var/www/drupal',
    #settings_file_source => 'drupal.local.settings.php',
    #settings_file_destination => 'sites/default/settings.php',
    #db_name => 'drupal_local',
    #add_vhost => true,
    #proxy_pass => $proxy_pass,
    #port => 8181,
  #}
}

define drupal_site(
  $domain,
  $docroot,
  $db_name = undef,
  $add_vhost = false,
  $docroot_owner = "vagrant",
  $docroot_group = "vagrant",
  $port = 80,
  $prod_domain = 'http://acme.com',
  $proxy_pass = undef,
  $settings_file_source = undef,
  $settings_file_destination = undef,
  $repo_path = undef,
  $repo_username = undef,
  $repo_password = undef
  ) {

  if $add_vhost {
    apache::vhost { $domain:
      priority => '10',
      vhost_name => '*',
      port => $port,
      docroot => $docroot,
      docroot_owner => $docroot_owner,
      docroot_group => $docroot_group,
      override => 'All',
      serveradmin => "admin@${domain}",
      serveraliases => ["www.${domain}",],
      proxy_pass      => $proxy_pass,
      notify          => Class['apache::service'],
    }
  } else {
    file { $docroot:
      ensure => directory,
      owner => $docroot_owner,
      group => $docroot_group
    }
  }

  if $db_name {
    mysql::db { $db_name:
      user => $db_name,
      password => $db_name,
      host => 'localhost',
      grant => ['all'],
    }

    exec { "sync-${domain}-db":
      command => "mysqldump -u${db_name} -p${db_name} --no-data --add-drop-table ${db_name} | grep ^DROP | mysql -u${db_name} -p${db_name} ${db_name} &&
zcat /vagrant/import-sites/${domain}/${domain}.sql.gz | mysql -u${db_name} -p${db_name} ${db_name} &&
echo \"imported ${domain}.sql.gz; remove this file to re-import.\" > /vagrant/import-sites/${domain}/${domain}.import.lock",
      unless => "ls /vagrant/import-sites/${domain}/${domain}.import.lock",
      onlyif => "ls /vagrant/import-sites/${domain}/${domain}.sql.gz",
      path => ['/bin/', '/usr/bin/'],
      timeout => 0, # DB dumps can take a long time to import, disable timeout.
      logoutput => true,
      require => [Mysql::Db["$db_name"]],
    }
  }

  exec { "sync-${domain}-dir":
    command => "sudo rsync -r --delete /vagrant/import-sites/${domain}/${domain}/ ${docroot}/ &&
sudo chown vagrant:vagrant -R * .* &&
sudo chmod -R u+w * .*",
    unless => "ls ${docroot}/index.php",
    onlyif => "ls /vagrant/import-sites/${domain}/${domain}/index.php",
    cwd => "${docroot}",
    path => ['/bin/', '/usr/bin/'],
    require => [Package['rsync'], File['/var/www']],
  }

  if $settings_file_source {
    exec { "copy-${domain}-settings":
      command => "rm ${docroot}/${settings_file_destination} &&
cp /vagrant/import-sites/${domain}/${settings_file_source} ${docroot}/${settings_file_destination}",
      onlyif => "ls /vagrant/import-sites/${domain}/${settings_file_source} && ls ${docroot}/index.php",
      path => ['/bin/', '/usr/bin/'],
      require => Exec["sync-${domain}-dir"],
    }
  }

  # Stub for cloning automatically the code from bitbucket.
  # Not working yet!
  #@TODO: try with git clone ssh://git@bitbucket.org/repo/path/reponame.git
  # - Note this requires setting up SSH forwarding from the host env + setting up SSH keys on bitbucket
  if $repo_path {
    exec { "clone $domain":
      command => "git clone https://${repo_username}@bitbucket.org/${repo_path}.git ${docroot} <<EOF
$repo_password
EOF",
      unless => "ls ${docroot}/index.php",
      require => Package['git'],
    }
  }
}


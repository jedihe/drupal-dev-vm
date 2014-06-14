class devel {

  package { ['screen', 'mailutils']:
    ensure => installed,
  }

  package { php5-xdebug:
    ensure => installed,
    require => Package['php5']
  }

  file { '/etc/php5/conf.d/xdebug.ini':
    ensure => 'present',
    content => "zend_extension=/usr/lib/php5/20090626+lfs/xdebug.so
xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000",
    mode   => 644,
    require => Package['php5-xdebug'],
  }

  # install xhprof. This requires beta install of xhprof.
  exec { 'install xhprof':
    command => "${pear_proxy_prefix}sudo pecl install -f xhprof-0.9.2",
    require => Package['php5-common'],
    creates => '/usr/lib/php5/20090626+lfs/xhprof.so',
    logoutput => true,
  }

  file { '/etc/php5/apache2/conf.d/xhprof.ini':
    ensure  => 'present',
    content => 'extension=xhprof.so
xhprof.output_dir=/var/tmp/xhprof',
    mode    =>  644,
    require => [
      Class['apache::mod::php'],
      Exec['install xhprof'],
      File['/var/tmp/xhprof']
    ],
  }

  file { '/etc/apache2/sites-enabled/xhprof.conf':
    ensure => 'present',
    content => '
Alias /xhprof_html /usr/share/php/xhprof_html

<Directory /usr/share/php/xhprof_html>
  Options FollowSymLinks
  DirectoryIndex index.php
</Directory>
    ',
    mode => 644,
    require => [Class['apache']],
    notify => Class['apache::service'],
  }

  file { '/var/tmp/xhprof':
    ensure => 'directory',
    mode => 664,
    owner => 'vagrant',
    group => 'www-data',
    require => [Exec['install xhprof']],
  }

  # Needed for callgraph functionality of XHProf
  package { 'graphviz':
    ensure => 'installed',
    require => [Exec['install xhprof']],
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

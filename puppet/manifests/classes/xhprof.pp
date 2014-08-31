class xhprof {
  # install xhprof. This requires beta install of xhprof.
  exec { 'install xhprof':
    command => "${pear_proxy_prefix}sudo pecl install -f xhprof-0.9.2",
    require => Package['php5-common'],
    creates => '/usr/lib/php5/20090626/xhprof.so',
  }

  file { '/var/tmp/xhprof':
    ensure => 'directory',
    mode => 664,
    owner => 'vagrant',
    group => 'www-data',
    require => [Exec['install xhprof']],
  }

  file { '/etc/php5/apache2/conf.d/xhprof.ini':
    ensure  => 'present',
    content => 'extension=xhprof.so
xhprof.output_dir=/var/tmp/xhprof',
    mode    =>  644,
    require => [
      Class['apache::mod::php'],
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
    require => [Class['apache'], Package['php5']],
    notify => Class['apache::service'],
  }

  # Needed for callgraph functionality of XHProf
  package { 'graphviz':
    ensure => 'installed',
    require => [Exec['install xhprof']],
  }
}

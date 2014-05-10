class runkit {
  exec { 'install runkit':
    command => "${pear_proxy_prefix}sudo pecl install https://github.com/downloads/zenovich/runkit/runkit-1.0.3.tgz",
    require => Package['php5'],
    #creates => '/usr/lib/php5/20090626+lfs/xhprof.so',
    unless => 'test -s /etc/php5/conf.d/runkit.ini',
    #logoutput => true,
  }

  file { '/etc/php5/conf.d/runkit.ini':
    ensure => "present",
    content => "extension=runkit.so
runkit.internal_override=1",
    require => Exec['install runkit'],
    notify => Class['apache::service'],
  }
}

class runkit {
  #curl::fetch_and_command { "install runkit":
    #source      => "https://github.com/downloads/zenovich/runkit/runkit-1.0.3.tgz",
    #destination => "/tmp/runkit-1.0.3.tgz",
    #timeout     => 30,
    #command => "sudo pecl install runkit-1.0.3.tgz",
    #command_cwd => "/tmp",
    #command_unless => 'ls /etc/php5/conf.d/runkit.ini',
    #verbose     => false,
  #}

  #file { '/etc/php5/conf.d/runkit.ini':
    #ensure => "present",
    #content => ";extension=runkit.so
#;runkit.internal_override=1",
    #require => Curl::Fetch_and_command['install runkit'],
    #notify => Class['apache::service'],
  #}
}

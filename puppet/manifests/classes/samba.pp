class samba {
  package { samba:
    ensure => installed,
  }

  file { "/etc/samba/smb.conf":
    ensure => present,
    source => "/vagrant/conf-files/smb.conf",
    path => "/etc/samba/smb.conf",
    mode => 644,
    #owner => "vagrant",
    #group => "vagrant",
    replace => true,
    require => Package['samba'],
    notify => [Service['smbd', 'nmbd']],
  }

  exec { "vagrant user for samba":
    command => "(echo vagrant; echo vagrant) | smbpasswd -a vagrant",
    path => ['/bin', '/usr/bin'],
  }

  #exec { 'restart samba':
  #  command => 'service smbd restart && service nmbd restart',
  #  path => ['/usr/bin'],
  #}

  service { 'smbd':
    name     => 'smbd',
    ensure   => 'running',
    enable   => true,
    require  => File['/etc/samba/smb.conf'],
    provider => 'upstart',
  }

  service { 'nmbd':
    name     => 'nmbd',
    ensure   => 'running',
    enable   => true,
    require  => File['/etc/samba/smb.conf'],
    provider => 'upstart',
  }
}

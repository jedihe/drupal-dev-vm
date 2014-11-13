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
  }
}

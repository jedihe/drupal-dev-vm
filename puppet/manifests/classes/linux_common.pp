class linux_common {
  if $::http_proxy != "" {
    file { "/etc/apt/apt.conf.d/30proxy":
      ensure  => "file",
      replace => true,
      content => "Acquire::http::Proxy \"${http_proxy}\";",
    }
    exec { "apt-update":
        command => "/usr/bin/apt-get update",
        require => File['/etc/apt/apt.conf.d/30proxy']
    }
  }
  else {
    exec { "apt-update":
        command => "/usr/bin/apt-get update",
    }
  }
  # Require apt-update for every Package command
  Exec["apt-update"] -> Package <| |>
  Package["puppet"] -> Augeas <| |>
  Package['libaugeas-ruby'] -> Augeas <| |>

  package { ['nfs-common', 'puppet', 'make', 'postfix', 'rsync', 'libxml-xpath-perl', 'unzip', 'inotify-tools', 'htop', 'zsh']:
    ensure => installed,
  }

  # replace puppet and ruby so we can use augeas for file config
  package { ['augeas-tools', 'libaugeas-ruby']:
    ensure => installed,
  }

  file { "/etc/postfix/main.cf":
    ensure => "file",
    replace => true,
    content => "myhostname = ${fqdn}
inet_interfaces = loopback-only
default_transport = error:postfix configured to not route email",
    require => Package['postfix']
  }

  # reload ssh
  exec {'reload ssh':
    command => "/etc/init.d/ssh restart",
    refreshonly => true,
  }

  # Allow agent forwarding inside the guest.
  augeas { 'ssh_allow_agent_forwarding':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set AllowAgentForwarding yes',
    ],
    notify => Exec['reload ssh']
  }

  exec { "oh-my-zsh":
    command => "git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh &&
    chown -R vagrant:vagrant .oh-my-zsh &&
    chsh -s /bin/zsh vagrant",
    logoutput => true,
    cwd => "/home/vagrant",
    path => ['/bin/', '/usr/bin/'],
    unless => "test -s /home/vagrant/.zshrc",
    require => [Class['git'], Package['zsh']],
  }

  file { '/home/vagrant/.zshrc':
    ensure => 'file',
    source => "/vagrant/import-sites/.zshrc",
    mode   => 664,
    owner => "vagrant",
    group => "vagrant",
    require => Exec['oh-my-zsh'],
  }
}
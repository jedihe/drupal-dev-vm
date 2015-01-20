class linux_common {
  if $::http_proxy != "" {
    file { "/etc/apt/apt.conf.d/30proxy":
      ensure  => "file",
      replace => true,
      content => "Acquire::http::Proxy \"${http_proxy}\";",
    }
  }
  else {
    file { "/etc/apt/apt.conf.d/30proxy":
      ensure  => "absent",
    }
  }

  exec { "apt-update":
      command => "/usr/bin/apt-get update",
      require => File['/etc/apt/apt.conf.d/30proxy']
  }

  # Require apt-update for every Package command
  Exec["apt-update"] -> Package <| |>
  Package["puppet"] -> Augeas <| |>
  Package['libaugeas-ruby'] -> Augeas <| |>

  $common_packages = [
    'exuberant-ctags',
    'nfs-common',
    'puppet',
    'make',
    'man',
    'postfix',
    'rsync',
    'libxml-xpath-perl',
    'unzip',
    'inotify-tools',
    'htop',
    'tmux',
    'zsh'
  ]

  package { $common_packages:
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
    creates => '/home/vagrant/.oh-my-zsh',
    logoutput => true,
    cwd => "/home/vagrant",
    path => ['/bin/', '/usr/bin/'],
    require => [Class['git'], Package['zsh']],
  }

  file { 'zshrc':
    ensure => present,
    source => "/vagrant/dotfiles/.zshrc",
    path => '/home/vagrant/.zshrc',
    mode   => 664,
    owner => "vagrant",
    group => "vagrant",
    replace => true,
    require => Exec['oh-my-zsh'],
  }
}

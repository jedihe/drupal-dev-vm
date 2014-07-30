class git {
  package { 'git':
    ensure => installed,
  }

  file { '/home/vagrant/.gitconfig':
    ensure => 'file',
    source => "/vagrant/dotfiles/.gitconfig",
    mode   => 664,
    owner => "vagrant",
    group => "vagrant",
    require => Package['git'],
  }

  if $::http_proxy != '' {
    git::config { "git-proxy":
      variable => "http.proxy",
      value => $::http_proxy,
      require => Package['git'],
    }
  }
  else {
    exec { "git-no-proxy":
      command => "git config --global --unset http.proxy",
      path => ['/bin', '/usr/bin'],
      user => 'vagrant',
    }
  }
}

define git::config (
  $variable,
  $value
) {

  if $variable != '' and $value != '' {
    exec { "git-config-$name":
      command => "git config --global $variable $value",
      timeout => 5,
      unless => "git config $variable | grep \"$value\"",
      user => 'vagrant',
      require => Package['git'],
      path => ['/bin', '/usr/bin'],
    }
  }
}

class git {
  package { 'git':
    ensure => installed,
  }

  file { '/home/vagrant/.gitconfig':
    ensure => 'file',
    source => "/vagrant/import-sites/.gitconfig",
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
      require => Package['git'],
      path => ['/bin', '/usr/bin'],
    }
  }
}

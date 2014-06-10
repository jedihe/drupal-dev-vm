class de_browsers {
  package { ['chromium-browser']:
    ensure => 'installed',
    require => [Exec['desktop environment']],
  }
}

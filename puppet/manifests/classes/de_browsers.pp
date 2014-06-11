class de_browsers {
  $browser_packages = [
    'chromium-browser',
    'firefox',
    'firefox-locale-en',
    'flashplugin-installer',
  ]

  package { $browser_packages:
    ensure => 'installed',
    require => [Exec['desktop environment']],
  }
}

define ppa_package (
  $ppa,
  $package
) {

  apt::ppa { $ppa: }
  package { $package:
    ensure => 'installed',
    require => Class['Apt::Update'],
  }
}

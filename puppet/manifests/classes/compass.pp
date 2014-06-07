class compass {
  package { ['ruby-compass', 'rubygems']:
    ensure => installed,
  }

  package { ['compass', 'sass', 'chunky_png', 'fssm', 'zurb-foundation']:
    ensure => 'installed',
    provider => 'gem',
    require => Package['rubygems']
  }
}

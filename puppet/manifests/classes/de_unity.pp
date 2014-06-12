class de_unity {
  include de_browsers

  exec { 'desktop environment':
    command => 'sudo apt-get install --no-install-recommends --yes --fix-missing ubuntu-desktop lightdm &&
echo "ubuntu-desktop-installed" > /home/vagrant/flag-ubuntu-desktop.txt',
    timeout => 0,
    unless => 'ls /home/vagrant/flag-ubuntu-desktop.txt',
    path      => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin",
    logoutput => true,
  }

  $unity_packages = [
    'firefox-globalmenu',
    'indicator-multiload',
    'libappindicator1',
    'indicator-datetime',
    'indicator-session',
    'indicator-sound',
    'network-manager-gnome',
    'ttf-ubuntu-font-family',
    'unity-lens-applications',
    'unity-lens-files',
  ]
  package { $unity_packages:
    ensure => 'installed',
  }

  #$remove_packages = [
    #'indicator-applet-appmenu',
    #'indicator-applet-session',
    #'indicator-messages',
    #'indicator-applet-complete',
  #]
  #package { $remove_packages:
    #ensure => 'purged',
  #}

  file { 'chromium launcher':
    source => '/usr/share/applications/chromium-browser.desktop',
    path => '/home/vagrant/Desktop/chromium-browser.desktop',
    owner => 'vagrant',
    group => 'vagrant',
    mode => 755,
    ensure => 'present',
    require => [Package['chromium-browser']],
  }
}

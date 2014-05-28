class gui_unity {
  exec { 'ubuntu-desktop':
    command => 'sudo apt-get install --no-install-recommends --yes --fix-missing ubuntu-desktop lightdm &&
echo "ubuntu-desktop-installed" > /home/vagrant/flag-ubuntu-desktop.txt',
    timeout => 0,
    unless => 'ls /home/vagrant/flag-ubuntu-desktop.txt',
    path      => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin",
    logoutput => true,
  }
}

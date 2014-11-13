# vi:syntax=ruby
# vi: set ft=ruby :

node "precise32" {
  include linux_common
  include drupal
  include devel
  include git
  include vim
  include phpmyadmin
  include memcached
  include apc
  include runkit
  include import_sites
  include php_testing
  include xhprof
  include xdebug
  # Uncomment to get a samba share for /var/www
  # WARNING: defaults are *INSECURE*, edit conf-files/smb.conf to secure as needed.
  #include samba

  # Uncomment to install Unity desktop environment
  #include de_unity

}


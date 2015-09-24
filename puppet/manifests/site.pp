# Reset the path to avoid /opt/vagrant_ruby (we use the default packaged libs)
file { '/etc/profile.d/vagrant_ruby.sh':
  ensure => absent,
}

Exec { path => [
    "/usr/local/sbin",
    "/usr/local/bin",
    "/usr/sbin",
    "/usr/bin",
    "/sbin:/bin",
  ]
}

import "classes/*"
import "nodes.pp"

if $::use_proxy == "1" {
  notice("Using proxy: ${http_proxy}.")
  $pear_proxy_prefix = "pear config-set http_proxy ${http_proxy} && "
}
else {
  notice("Not using proxy.")
  $pear_proxy_prefix = ""
}

notice("Using host uid: $::host_uid.")

class curl() {
  package { "curl": ensure => 'installed' }
}

define curl::fetch(
  $source,
  $destination,
  $timeout,
  $verbose = false
) {

  if $verbose {
    $verbose_option = "--verbose"
    $logoutput      = true
  }
  else {
    $verbose_option = "--silent --show-error"
    $logoutput      = false
  }

  if $::http_proxy {
    $proxy_option = "--proxy $::http_proxy"
  }
  else {
    $proxy_option = ""
  }

  exec { "curl-fetch-$name":
    command   => "curl $proxy_option $verbose_option --output $destination $source",
    timeout   => $timeout,
    unless    => "test -s $destination",
    logoutput => $logoutput,
    path      => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin",
    require   => Class["curl"],
  }
}

define curl::fetch_and_command(
  $source,
  $destination,
  $timeout,
  $command        = "",
  $command_cwd    = "",
  $command_unless = "",
  $verbose        = false
) {
  include curl

  curl::fetch { "curl-$name":
    source      => $source,
    destination => $destination,
    timeout     => $timeout,
    verbose     => $verbose
  }

  exec { "curl-fetch-command-$name":
    command => $command,
    unless  => $command_unless,
    timeout => $timeout,
    cwd     => $command_cwd,
    path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin",
    require => Curl::Fetch["curl-$name"],
  }
}

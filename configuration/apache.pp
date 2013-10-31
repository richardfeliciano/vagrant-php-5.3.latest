class { 'apache':
    mpm_module => 'prefork',
}
class { 'apache::mod::php': }

include apache

apache::mod { 'rewrite': }
apache::mod { 'headers': }
apache::mod { 'expires': }

file { "/srv/log":
    ensure => "directory",
}

define generate_vhost {

  $vhost = split($name,',')

  $vhost_name = rstrip($vhost[0])
  $vhost_docroot = rstrip($vhost[1])

  apache::vhost { $vhost_name :
      port            => '80',
      docroot         => $vhost_docroot,
      logroot         => '/srv/log',
      override        => ['All'],
      docroot_owner   => 501,
      docroot_group   => 80
  }
}

if $vhosts {
  $vhosts_array = split($vhosts, " ")
  generate_vhost { $vhosts_array: }
}


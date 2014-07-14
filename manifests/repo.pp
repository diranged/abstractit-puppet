# # setup the puppetlabs repo

class puppet::repo (
  $devel_repo = $puppet::params::devel_repo,) inherits puppet::params {
  if ($::osfamily == 'Debian') {
    class { 'puppet::repo::apt': devel_repo => $devel_repo, }

  } elsif ($::osfamily == 'RedHat') {
    class { 'puppet::repo::yum': devel_repo => $devel_repo, }

  }
}

# install client packages

class puppet::install (
  $puppet_version = 'installed',
  $hiera_version  = 'installed',
  $facter_version = 'installed') inherits puppet::params {
  #package { 'puppetlabs-release': ensure => latest, }

  package { 'puppet':
    ensure  => $puppet_version,
    require => [
      Package['hiera'],
      Package['facter'],
      ]
  }

  package { 'hiera': ensure => $hiera_version, }

  package { 'facter': ensure => $facter_version, }

}

# setup repos for apt

class puppet::repo::apt (
  $devel_repo = $puppet::params::devel_repo,) inherits puppet::params {
  $os_name_lc = downcase($::operatingsystem)

  include ::apt

  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main dependencies',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

  apt::source { 'puppetlabs_devel':
    ensure     => $devel_repo ? {
      default => absent,
      true    => present,
    },
    location   => 'http://apt.puppetlabs.com',
    repos      => 'devel',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

}

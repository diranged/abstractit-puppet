# # puppet agent service

class puppet::agent (
  $enable = true,
  $ensure = true) inherits puppet::params {
  service { 'puppet':
    ensure  => $ensure,
    enable  => $enable,
    require => Class['puppet::config']
  }

}

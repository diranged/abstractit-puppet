# # class puppet::config
# config for puppet agent

class puppet::config (
) {
  include ::puppet
  $puppet_server    = $::puppet::puppet_server
  $environment      = $::puppet::environment
  $runinterval      = $::puppet::runinterval
  $structured_facts = $::puppet::structured_facts

  validate_string(
    $environment,
    $puppet_server,
    $runinterval,
    )
  validate_bool($structured_facts)
  $stringify_facts = $structured_facts ? {
    default => true,
    true    => false,
  }

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $puppet_server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client environment':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value   => $environment,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client runinterval':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'runinterval',
    value   => $runinterval,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client structured_facts':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'stringify_facts',
    value   => $stringify_facts,
    require => Class['puppet::install'],
  }

}

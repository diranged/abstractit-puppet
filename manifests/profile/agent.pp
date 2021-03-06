class puppet::profile::agent (
  $agent_cron_hour           = '*',
  $agent_cron_min            = 'two_times_an_hour',
  $devel_repo                = false,
  $enabled                   = true,
  $enable_devel_repo         = false,
  $enable_mechanism          = 'service',
  $enable_repo               = true,
  $environment               = 'production',
  $facter_version            = 'installed',
  $hiera_version             = 'installed',
  $manage_etc_facter         = true,
  $manage_etc_facter_facts_d = true,
  $manage_repos              = true,
  $puppet_server             = 'puppet',
  $puppet_version            = 'installed',
  $runinterval               = '30m',
  $structured_facts          = false,
  $puppet_reports            = true,
  $custom_facts              = undef,
) {
  class { 'puppet':
    agent_cron_hour           => $agent_cron_hour,
    agent_cron_min            => $agent_cron_min,
    devel_repo                => $devel_repo,
    enabled                   => $enabled,
    enable_devel_repo         => $enable_devel_repo,
    enable_mechanism          => $enable_mechanism,
    enable_repo               => $enable_repo,
    environment               => $environment,
    facter_version            => $facter_version,
    hiera_version             => $hiera_version,
    manage_etc_facter         => $manage_etc_facter,
    manage_etc_facter_facts_d => $manage_etc_facter_facts_d,
    manage_repos              => $manage_repos,
    puppet_server             => $puppet_server,
    puppet_version            => $puppet_version,
    runinterval               => $runinterval,
    structured_facts          => $structured_facts,
    reports                   => $puppet_reports,
    custom_facts              => $custom_facts,
  }

}

class puppet::profile::r10k (
  $version                   = undef,
  $remote                    = undef,
  $sources                   = undef,
  $r10k_basedir              = '/etc/puppet/r10kenv',
  $purgedirs                 = undef,
  $cachedir                  = undef,
  $configfile                = '/etc/r10k.yaml',
  $include_prerun_command    = false,
  $r10k_cron                 = false,
  $env_owner                 = 'puppet',
  $r10k_minutes              = [
    0,
    15,
    30,
    45],
) {

  class { '::r10k':
    version                   => $version,
    remote                    => $remote,
    sources                   => $sources,
    r10k_basedir              => $r10k_basedir,
    purgedirs                 => $purgedirs,
    cachedir                  => $cachedir,
    configfile                => $configfile,
    include_prerun_command    => $include_prerun_command,
  }

  # cron for updating the r10k environment
  cron { 'puppet_r10k':
    ensure      => $r10k_cron ? {
      default => present,
      false   => absent,
    },
    command     => '/usr/local/bin/r10k deploy environment production -p',
    environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
    user        => $env_owner,
    minute      => $r10k_minutes
  }
}

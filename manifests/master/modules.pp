# # Class puppet::master::modules

class puppet::master::modules (
  $env_owner        = 'puppet',
  $extra_env_repos  = undef,
  $hiera_repo       = undef,
  $puppet_env_repo  = undef,
  $r10k_env_basedir = '/etc/puppet/r10kenv',
  $r10k_minutes     = [
    0,
    15,
    30,
    45],
  $r10k_purgedirs   = true,
  $r10k_update      = true,
) {
  #input validation
  validate_absolute_path($r10k_env_basedir)


  validate_bool(
    $r10k_purgedirs,
    $r10k_update
  )

  validate_string($env_owner)

  if $hiera_repo {
    validate_string($hiera_repo)
  }

  if $puppet_env_repo {
    validate_string($puppet_env_repo)
  }

  if $extra_env_repos {
    validate_hash($extra_env_repos)
  }

  # r10k setup
  file { '/var/cache/r10k':
    ensure  => directory,
    owner   => $env_owner,
    group   => $env_owner,
    mode    => '0700',
    require => Package['r10k']
  }

  file { '/etc/r10k.yaml':
    ensure  => file,
    content => template('puppet/r10k.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/var/cache/r10k']
  }

  file { $r10k_env_basedir:
    ensure => directory,
    owner  => $env_owner,
    group  => $env_owner,
    mode   => '0755'
  }

  # cron for updating the r10k environment
  cron { 'puppet_r10k':
    ensure      => $r10k_update ? {
      default => present,
      false   => absent,
    },
    command     => '/usr/local/bin/r10k deploy environment production -p',
    environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
    user        => $env_owner,
    minute      => $r10k_minutes
  }
}

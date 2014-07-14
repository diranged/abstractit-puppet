# setup repos for yum

class puppet::repo::yum (
  $devel_repo = $puppet::params::devel_repo,) inherits puppet::params {
  $os_name_lc = downcase($::operatingsystem)

  case $::operatingsystem {
    'RedHat', 'CentOS' : {
      yumrepo { 'puppetlabs-products':
        name     => 'Puppet Labs Products El 6 - $basearch',
        baseurl  => 'http://yum.puppetlabs.com/el/6/products/$basearch',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
        enabled  => 1,
        gpgcheck => 1,
      }

      yumrepo { 'puppetlabs-deps':
        name     => 'Puppet Labs Dependencies El 6 - $basearch',
        baseurl  => 'http://yum.puppetlabs.com/el/6/dependencies/$basearch',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
        enabled  => 1,
        gpgcheck => 1,
      }

      yumrepo { 'puppetlabs-devel':
        name     => 'Puppet Labs Devel El 6 - $basearch',
        baseurl  => 'http://yum.puppetlabs.com/el/6/devel/$basearch',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
        enabled  => $devel_repo ? {
          default => 0,
          true    => 1,
        },
        gpgcheck => 1,
      }
    }
  }
}

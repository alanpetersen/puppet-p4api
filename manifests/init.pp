# Class: p4api
# ===========================
#
# Full description of class p4api here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'p4api':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class p4api (
  $version = $p4api::params::version,
  $base_download_url = $p4api::params::base_download_url,
  $create_symlink = $p4api::params::create_symlink,
  $base_perforce_dir = $p4api::params::base_perforce_dir,
  $manage_base_dir = $p4api::params::manage_base_dir,
  $dist_dir = $p4api::params::dist_dir,
  $osuser = $p4api::params::osuser,
  $osgroup = $p4api::params::osgroup,
  $symlink_name = $p4api::params::symlink_name,
  $staging_dir = $p4api::params::staging_dir,
) inherits p4api::params {

  if $manage_base_dir {
    if !defined(File[$base_perforce_dir]) {
      file { $base_perforce_dir:
        ensure => directory,
        owner  => $osuser,
        group  => $osgroup,
        mode   => '0755',
      }
    }
  }

  $download_url = "${base_download_url}/r${version}/${dist_dir}/p4api.tgz"

  # manage the staging class
  class { 'staging':
    path  => $staging_dir,
  }

  # download the staged file
  staging::file { 'p4api.tgz':
    source => $download_url,
  }

  staging::extract { 'p4api.tgz':
    target  => $base_perforce_dir,
    user    => $osuser,
    group   => $osgroup,
    creates => "${base_perforce_dir}/${symlink_name}/lib/libclient.a",
    require => [Staging::File['p4api.tgz']],
  }

  if $create_symlink {
    $gen_symlink_cmd = '/tmp/gen_symlink.sh'
    $staging_file = "${staging_dir}/p4api/p4api.tgz"

    file {$gen_symlink_cmd:
      ensure  => file,
      content => template('p4api/gen_symlink.erb'),
      mode    => '0700',
      owner   => $osuser,
      group   => $osgroup,
    }

    exec { 'create_symlink':
      command   => $gen_symlink_cmd,
      user      => $osuser,
      group     => $osgroup,
      logoutput => true,
      path      => '/bin:/usr/bin:/usr/local/bin',
      creates   => "${base_perforce_dir}/${symlink_name}",
      require   => Staging::Extract['p4api.tgz'],
    }
  }

}

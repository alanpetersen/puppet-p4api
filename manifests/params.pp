#
class p4api::params {

  $version = '15.2'
  $base_download_url = 'ftp://ftp.perforce.com/perforce'
  $staging_dir = '/var/staging'
  $base_perforce_dir = '/opt/perforce'
  $manage_base_dir = true
  $create_symlink = true
  $symlink_name = 'p4api'
  case $::kernel {
    'Linux': {
      $osuser = 'root'
      $osgroup = 'root'
      if $::kernelmajversion in ['2.6','3.16'] {
        if $::architecture in ['x86_64','amd64'] {
          $dist_dir = 'bin.linux26x86_64'
        } else {
          $dist_dir = 'bin.linux26x86'
        }
      } else {
        fail("${::kernelmajversion} is not currently supported")
      }
    }
    default: {
      fail("${::kernel} is not currently supported")
    }
  }
}

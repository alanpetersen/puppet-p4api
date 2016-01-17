# p4api

## Overview
This module manages the Perforce API installation on Linux systems.

## Usage
At a minimum, you can accept the defaults and simply use `include p4api` to manage the Perforce API on the node.

You can override defaults using hiera, or by specifying parameters when declaring the p4api class. For example:

~~~
class { 'p4api':
  version => '14.3',
  osuser  => 'perforce',
  osgroup => 'perforce',
}
~~~

### Parameters
* `version` - the P4API version you want to manage. This defaults to `15.2`.
* `base_download_url` - the base URL from which the P4API distribution will be downloaded. This defaults to `ftp://ftp.perforce.com/perforce`.
* `dist_dir` - the distribution directory (under the r${version} directory) that will contain the distribution tarball. This is calculated in the `params` class.
* `base_perforce_dir` - the base directory where the P4API (and symlink) will be created. This defaults to `/opt/perforce`.
* `manage_base_dir` - a boolean indicating whether or not this module should attempt to manage the base directory. This defaults to `true`. You might want to set this to false, for example, if some other Perforce product (like GitFusion) is also being managed on the system.
* `create_symlink` - a boolean indicating whether or not the symlink should be created. This defaults to `true`.
* `symlink_name` - the name of the symlink that will point to the actual P4API distribution directory. This defaults to `p4api`.
* `osuser` - the OS user account that will own the P4API directory and symlink. This defaults to `root`. This module will NOT manage the user... that should be done separately.
* `osgroup` - the OS group that will own the P4API directory and symlink. This defaults to `root`. This module will NOT manage the group... that should be done separately.
* `staging_dir` - the directory where the P4API distribution will be downloaded. This defaults to `/var/staging`. The distribution will be downloaded into the `p4api` subdirectory.

  
## Limitations
Currently, the module only supports Linux. A Windows version is being considered.

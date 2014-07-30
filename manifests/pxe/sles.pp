# Setup sles/sled images in PXE

define quartermaster::pxe::sles (
   $distro,
   $p_arch,
   $release,
   $rel_num
) {
   if $release =~/([0-9]+).([0-9])/{
	  $rel_major = $1
	  $rel_minor = $2
   } else {
      $rel_major = $release
   }
   
   # Create file/directory structure
   quartermaster::pxe::structure { "${name}":
      distro          => $distro,
	  p_arch          => $p_arch,
	  linux_installer => 'yast',
	  autofile        => $'autoyast',
	  puppetlabs_repo => "No PuppetLabs Repo",
	  inst_repo       => "Enterprise ISO Required",
	  update_repo     => "Enterprise ISO Required"
   }
}
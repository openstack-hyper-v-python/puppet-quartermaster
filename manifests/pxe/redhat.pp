# Setup redhat images in PXE

define quartermaster::pxe::redhat (
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
	  linux_installer => 'anaconda',
	  autofile        => $'kickstart',
	  puppetlabs_repo => "http://yum.puppetlabs.com/el/${rel_major}/products/${p_arch}",
	  inst_repo       => "Enterprise ISO Required",
	  update_repo     => "Enterprise ISO Required"
   }
}
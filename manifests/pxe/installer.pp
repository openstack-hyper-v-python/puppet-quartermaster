# Setup an entry in the pxe boot options

define quartermaster::pxe::installer (
   $distro,
   $p_arch,
   $release,
) {
   case $distro {
      ubuntu,debian: {
	     quartermaster::pxe::debian { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  centos: {
	     quartermaster::pxe:centos { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  fedora: {
	     quartermaster::pxe:centos { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  scientificlinux: {
	     quartermaster::pxe:centos { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  sles,sled: {
	     quartermaster::pxe:sles { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  redhat: {
	     quartermaster::pxe:redhat { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  opensuse: {
	     quartermaster::pxe:opensuse { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
	  oraclelinux: {
	     quartermaster::pxe:oracle { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
		 }
	  }
   }
}
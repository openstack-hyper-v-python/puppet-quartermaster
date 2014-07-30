# Class: quartermaster::pxe::installer
# 
# This class helps to break apart logical issues for each distro
#

define quartermaster::pxe::installer (
   $distro,
   $p_arch,
   $release,
   $rel_num
) {
   case $distro {
      ubuntu,debian: {
	     quartermaster::pxe::debian { "${name}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  centos: {
	     quartermaster::pxe:centos { "${name}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  scientificlinux: {
	     quartermaster::pxe:scientific { "${name}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  fedora: {
	     quartermaster::pxe:centos { "${name}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  sles,sled: {
	     quartermaster::pxe:sles { "${name}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  redhat: {
	     quartermaster::pxe:redhat { "${name}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  opensuse: {
	     quartermaster::pxe:opensuse { "${name}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  oraclelinux: {
	     quartermaster::pxe:oracle { "${name}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_num   => $rel_num
		 }
	  }
	  default: {
	     fail("$(distro) is not configured for pxe boot!")
	  }
   }
}
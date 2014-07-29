# Class: quartermaster::pxe::installer
# 
# This class helps to break apart logical issues for each distro
#

define quartermaster::pxe::installer (
   $distro,
   $p_arch,
   $release,
   $rel_name,
   $rel_num,
) {
   case $distro {
      ubuntu,debian: {
	     quartermaster::pxe::debian { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  centos,scientificlinux: {
	     quartermaster::pxe:centos { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  fedora: {
	     quartermaster::pxe:centos { "${distro}-${release}-${p_arch}":
		    distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  sles,sled: {
	     quartermaster::pxe:sles { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  redhat: {
	     quartermaster::pxe:redhat { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  opensuse: {
	     quartermaster::pxe:opensuse { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  oraclelinux: {
	     quartermaster::pxe:oracle { "${distro}-${release}-${p_arch}":
		 	distro    => $distro,
		    p_arch    => $p_arch,
			release   => $release,
			rel_name  => $rel_name,
			rel_num   => $rel_num,
		 }
	  }
	  default: {
	     fail("$(distro) is not configured for pxe boot!")
	  }
   }
}
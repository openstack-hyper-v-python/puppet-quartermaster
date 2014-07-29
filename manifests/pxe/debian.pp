# Setup debian/ubuntu images in PXE

define quartermaster::pxe::debian (
   $distro,
   $p_arch,
   $release,
   $rel_name,
   $rel_num
) {
   # Note: both debian and ubuntu use the same url structure
   $target = "${rel_name}/main/installer-${p_arch}/current/images/netboot/${distro}-installer/${p_arch}"
   $baseurl = $distro ? {
      /(ubuntu)/   => "http://archive.ubuntu.com/${distro}/dists",
	  /(debian)/   => "http://ftp.debian.org/${distro}/dists",
	  default     => "http://mirrors.kernel.org/${distro}/dists",
   }
   $url = "${baseurl}/${target}"
   
   # Get the kernel
   exec {"get_net_kernel-${name}":
     command => "/usr/bin/wget -c ${url}/linux -O ${rel_num}",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }

   # Get the initrd
   exec {"get_net_initrd-${name}":
     command => "/usr/bin/wget -c ${url}/initrd.gz -O ${rel_num}.gz",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}.gz",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }
}
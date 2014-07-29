# Setup debian/ubuntu images in PXE

define quartermaster::pxe::debian (
   $distro,
   $p_arch,
   $release,
) {
   # Convert release to correct naming for URL
   $rel_name = $release ? {
     /(11.04)/    => 'natty',
     /(11.10)/    => 'oneric',
     /(12.04)/    => 'precise',
     /(12.10)/    => 'quantal',
     /(13.04)/    => 'raring',
     /(13.10)/    => 'saucy',
     /(14.04)/    => 'trusty',
     /(stable)/   => 'squeeze',
     /(testing)/  => 'wheezy',
     /(unstable)/ => 'sid',
     default      => "Unsupported ${distro} Release",
   }
   
   # remove periods from release (12.04 -> 1204)
   $rel_num = regsubst($release, '(\.)','','G')
   
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
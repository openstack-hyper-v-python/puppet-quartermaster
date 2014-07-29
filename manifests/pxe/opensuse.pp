# Setup suse images in PXE

define quartermaster::pxe::opensuse (
   $distro,
   $p_arch,
   $release,
) {
   $target = "repo/oss/boot/${p_arch}/loader"
   $baseurl = "http://download.opensuse.org/distribution/${release}"
   
   # remove periods from release (6.5 -> 65)
   $rel_num = regsubst($release, '(\.)','','G')
	   
   # Note: we can use the kernel.org mirror to limit the needed classes
   $url = $(baseurl)/${target}
   
   # Get the kernel
   exec {"get_net_kernel-${name}":
     command => "/usr/bin/wget -c ${url}/linux -O ${rel_num}",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }

   # Get the initrd
   exec {"get_net_initrd-${name}":
     command => "/usr/bin/wget -c ${url}/initrd -O ${rel_num}",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }
}
# Setup debian/ubuntu images in PXE

define quartermaster::pxe::fedora (
   $distro,
   $p_arch,
   $release,
   $rel_name,
   $rel_num
) {
   if ($release < 18) {
      $legacy = 'true'
   } else {
      $legacy = 'false'
   }

   $target = "${distro}/linux/releases/${release}/Fedora/${p_arch}/os/images/pxeboot"
   $baseurl = $legacy ? {
      /(true)/   => "http://archives.fedoraproject.org/pub/archive",
	  /(false)/   => "http://dl.fedoraproject.org/pub",
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
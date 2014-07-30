# Setup fedora images in PXE

define quartermaster::pxe::fedora (
   $distro,
   $p_arch,
   $release,
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
     command => "/usr/bin/wget -c ${url}/vmlinuz -O ${rel_num}",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }

   # Get the ramdisk
   exec {"get_net_initrd-${name}":
     command => "/usr/bin/wget -c ${url}/initrd.img -O ${rel_num}.img",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}.img",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }

   # Create file/directory structure
   quartermaster::pxe::structure { "${name}":
      distro          => $distro,
	  p_arch          => $p_arch,
	  linux_installer => 'anaconda',
	  autofile        => 'kickstart',
	  puppetlabs_repo => "http://yum.puppetlabs.com/fedora/f${rel_num}/products/${p_arch}",
	  inst_repo       => "${baseurl}/${distro}/linux/releases/${release}/Fedora/${p_arch}/os",
	  update_repo     => "${baseurl}/${distro}/linux/releases/${release}/Fedora/${p_arch}/os"
   }
}
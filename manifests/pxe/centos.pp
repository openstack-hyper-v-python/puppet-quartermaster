# Setup centos images in PXE

define quartermaster::pxe::centos (
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
   
   $legacy = $rel_minor ? {
	   /(0|1|2|3|4)/ => 'true',
	   /(5)/         => 'false',
   }
   
   $target = "/os/${p_arch}/images/pxeboot"
   $baseurl = $legacy ? {
	   /(true)/   => "http://vault.centos.org/${release}",
	   /(false)/  => "http://mirror.centos.org/centos/${rel_major}",
   }
	   
   # Note: we can use the kernel.org mirror to limit the needed classes
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
	  puppetlabs_repo => "http://yum.puppetlabs.com/el/${rel_major}/products/${p_arch}",
	  inst_repo       => "${baseurl}/os/${p_arch}/",
	  update_repo     => "${baseurl}/updates/${p_arch}/",
	  splashurl       => "${baseurl}/os/${p_arch}/isolinux/splash.jpg"
   }
}
# Setup centos/scientific images in PXE

define quartermaster::pxe::centos (
   $distro,
   $p_arch,
   $release,
   $rel_name,
   $rel_num
) {
   if $distro == "scientificlinux" {
   	  $target = "${p_arch}/os/images/pxeboot"
      $baseurl = "http://ftp.scientificlinux.org/linux/scientific/${release}"
   } else {
	  if $release =~/([0-9]+).([0-9])/{
		$rel_major = $1
		$rel_minor = $2
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
   }
	   
   # Note: we can use the kernel.org mirror to limit the needed classes
   $url = $(baseurl)/${target}
   
   # Get the kernel
   exec {"get_net_kernel-${name}":
     command => "/usr/bin/wget -c ${url}/vmlinuz -O ${rel_num}",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }

   # Get the initrd
   exec {"get_net_initrd-${name}":
     command => "/usr/bin/wget -c ${url}/initrd.img -O ${rel_num}.img",
     cwd     => "${quartermaster::tftpboot}/${distro}/${p_arch}",
     creates => "${quartermaster::tftpboot}/${distro}/${p_arch}/${rel_num}.img",
     require =>  [Class['quartermaster::squid_deb_proxy'], Tftp::File[ "${distro}/${p_arch}" ]],
   }
}
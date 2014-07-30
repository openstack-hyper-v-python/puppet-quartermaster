# Setup suse images in PXE

define quartermaster::pxe::opensuse (
   $distro,
   $p_arch,
   $release,
   $rel_name,
   $rel_num
) {
   $target = "repo/oss/boot/${p_arch}/loader"
   $baseurl = "http://download.opensuse.org/distribution/${release}"
	   
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
   
   # Create file/directory structure
   quartermaster::pxe::structure { "${name}":
      distro          => $distro,
	  p_arch          => $p_arch,
	  linux_installer => 'yast',
	  autofile        => $'autoyast',
	  puppetlabs_repo => "No PuppetLabs Repo",
	  inst_repo       => "${baseurl}/repo/oss/boot/${p_arch}/loader",
	  update_repo     => "${baseurl}/repo/non-oss/suse"
   }
}
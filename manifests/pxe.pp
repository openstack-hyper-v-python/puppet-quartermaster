# Class: quartermaster::pxe
#
# This Class defines the creation of the linux pxe infrastructure
#

define quartermaster::pxe {
  # name must be in the format (distroName-release-arch), example: Ubuntu-Oneiric-AMD64
  if $name =~ /([a-zA-Z0-9_\.]+)-([a-zA-Z0-9_\.]+)-([a-zA-Z0-9_\.]+)/ {
    $distro  = $1
    $release = $2
    $p_arch  = $3
  }
  else {
    fail("Invalid formatting of name. ${name}")
  }
  
  # download the kernel, ramdisk, and create file/directory structure
  quartermaster::pxe::installer{ "${name}":
     distro    => $distro,
     p_arch    => $p_arch,
     release   => $release,
     rel_num   => regsubst($release, '(\.)','','G')
  }
}

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
  
  # convert debian/ubuntu release to correct naming for URL
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
  
  # download the kernel and ramdisk
  quartermaster::pxe::installer{ "${distro}-${release}-${p_arch}":
  	 distro    => $distro,
     p_arch    => $p_arch,
	 release   => $release,
	 rel_name  => $rel_name,
	 rel_num   => $rel_num,
  }
  
  $inst_repo = $distro ? {
    /(ubuntu)/          => "http://archive.ubuntu.com/${distro}/dists/${rel_name}",
    /(debian)/          => "http://ftp.debian.org/${distro}/dists/${rel_name}",
    /(centos)/          => "${centos_url}/os/${p_arch}/",
    /(fedora)/          => "${fedora_url}/${distro}/linux/releases/${release}/Fedora/${p_arch}/os",
    /(scientificlinux)/ => "http://ftp.scientificlinux.org/linux/scientific/${release}/${p_arch}/os",
    /(oraclelinux)/     => "http://public-yum.oracle.com/repo/OracleLinux/OL${rel_major}/${rel_minor}/base/${p_arch}/",
    /(redhat)/          => 'Enterprise ISO Required',
    /(sles)/            => 'Enterprise ISO Required',
    /(sled)/            => 'Enterprise ISO Required',
    /(opensuse)/        => "http://download.opensuse.org/distribution/${release}/repo/oss/boot/${p_arch}/loader",
    default             => 'No URL Specified',
  }

  $update_repo = $distro ? {
    /(ubuntu)/          => "http://archive.ubuntu.com/${distro}/dists/${rel_name}",
    /(debian)/          => "http://ftp.debian.org/${distro}/dists/${rel_name}",
    /(centos)/          => "${centos_url}/updates/${p_arch}/",
    /(fedora)/          => "${fedora_url}/${distro}/linux/releases/${release}/Fedora/${p_arch}/os",
    /(scientificlinux)/ => "http://ftp.scientificlinux.org/linux/scientific/${release}/${p_arch}/updates/security",
    /(oraclelinux)/     => "http://public-yum.oracle.com/repo/OracleLinux/OL${rel_major}/${rel_minor}/base/${p_arch}/",
    /(redhat)/          => 'Enterprise ISO Required',
    /(sles)/            => 'Enterprise ISO Required',
    /(sled)/            => 'Enterprise ISO Required',
    /(opensuse)/        => "http://download.opensuse.org/distribution/${release}/repo/non-oss/suse",
    default             => 'No URL Specified',
  }

  $autofile = $distro ? {
    /(ubuntu|debian)/                                    => 'preseed',
    /(redhat|centos|fedora|scientificlinux|oraclelinux)/ => 'kickstart',
    /(sles|sled|opensuse)/                               => 'autoyast',
    /(windows)/                                          => 'unattend.xml',
    default                                              => 'No supported automated installation method',
  }

  $linux_installer = $distro ? {
    /(ubuntu|debian)/                                    => 'd-i',
    /(redhat|centos|fedora|scientificlinux|oraclelinux)/ => 'anaconda',
    /(sles|sled|opensuse)/                               => 'yast',
    default                                              => 'No Supported Installer',
  }

  $puppetlabs_repo = $distro ? {
    /(ubuntu|debian)/                                    => "http://apt.puppetlabs.com/dists/${rel_name}",
    /(fedora)/                                           => "http://yum.puppetlabs.com/fedora/f${rel_number}/products/${p_arch}",
    /(redhat|centos|scientificlinux|oraclelinux)/        => "http://yum.puppetlabs.com/el/${rel_major}/products/${p_arch}",
    default                                              => 'No PuppetLabs Repo',
  }

  # create directory structure
  if ! defined (Tftp::File["${distro}"]){
    tftp::file { "${distro}":
      ensure  => directory,
      require =>  File[$quartermaster::tftpboot],
    }
  }

  if ! defined (Tftp::File["${distro}/menu"]){
    tftp::file { "${distro}/menu":
      ensure  => directory,
      require => Tftp::File["${distro}"],
    }
  }

  if ! defined (Tftp::File["${distro}/graphics"]){
    tftp::file { "${distro}/graphics":
      ensure  => directory,
      require => Tftp::File["${distro}"],
    }
  }
  
  tftp::file  { "${distro}/menu/${name}.graphics.conf":
      ensure  => file,
      require => Tftp::File[ "${distro}/menu" ],
      content => template("quartermaster/pxemenu/${linux_installer}.graphics.erb"),
  }

  if ! defined (Tftp::File["${distro}/${p_arch}"]){
    tftp::file { "${distro}/${p_arch}":
      ensure  => directory,
      require => Tftp::File[ "${distro}" ],
    }
  }

  if ! defined (File["${quartermaster::wwwroot}/${distro}"]) {
    file { "${quartermaster::wwwroot}/${distro}":
      ensure  => directory,
      owner   => 'tftp',
      group   => 'tftp',
      mode    => '0644',
      require => File[ $quartermaster::wwwroot ],
    }
  }

  if ! defined (File["${quartermaster::wwwroot}/${distro}/${autofile}"]) {
    file { "${quartermaster::wwwroot}/${distro}/${autofile}":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require => File[ $quartermaster::wwwroot ],
    }
  }
  
  if ! defined (File["${quartermaster::wwwroot}/${distro}/${p_arch}"]) {
    file { "${quartermaster::wwwroot}/${distro}/${p_arch}":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require => File[ $quartermaster::wwwroot ],
    }
  }
  
  if ! defined (File["${quartermaster::wwwroot}/${distro}/ISO"]) {
    file { "${quartermaster::wwwroot}/${distro}/ISO":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require => File[$quartermaster::wwwroot],
    }
  }
  
  file { "${name}.${autofile}":
    ensure  => file,
    path    => "${quartermaster::wwwroot}/${distro}/${autofile}/${name}.${autofile}",
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template("quartermaster/autoinst/${autofile}.erb"),
    require => File[ "${quartermaster::wwwroot}/${distro}/${autofile}" ],
   }

  if ! defined (Concat::Fragment["${distro}.default_menu_entry"]) {
    concat::fragment { "${distro}.default_menu_entry":
      target  => "${quartermaster::tftpboot}/pxelinux/pxelinux.cfg/default",
      content => template("quartermaster/pxemenu/default.erb"),
    }
  }
  
  if ! defined (Concat["${quartermaster::tftpboot}/menu/${distro}.menu"]) {
    concat { "${quartermaster::tftpboot}/menu/${distro}.menu":
      owner   => 'tftp',
      group   => 'tftp',
      mode    => $quartermaster::file_mode,
      require => Class['tftp'],
    }
  }
  
  if ! defined (Concat::Fragment["${distro}.submenu_header"]) {
    concat::fragment {"${distro}.submenu_header":
      target  => "${quartermaster::tftpboot}/menu/${distro}.menu",
      content => template("quartermaster/pxemenu/header2.erb"),
      order   => 01,
    }
  }
  
  if ! defined (Concat::Fragment["${distro}${name}.menu_item"]) {
    concat::fragment {"${distro}.${name}.menu_item":
      target  => "${quartermaster::tftpboot}/menu/${distro}.menu",
      content => template("quartermaster/pxemenu/${linux_installer}.erb"),
    }
  }

  tftp::file { "${distro}/menu/${name}.menu":
    ensure  => file,
    require => Tftp::File[ "${distro}/menu" ],
    content => template("quartermaster/pxemenu/${linux_installer}.erb"),
  }
}

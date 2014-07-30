define quartermaster::pxe::structure (
   $distro,
   $p_arch,
   $linux_installer,
   $autofile,
   $puppetlabs_repo,
   $inst_repo,
   $update_repo,
   $splashurl
) {

  if $splashurl =~ /(\.[^.]+)/ {
     $bootsplash = $2
	 exec {"get_bootsplash-${name}":
        command => "/usr/bin/wget -c ${splashurl}  -O ${name}${bootsplash}",
        cwd     => "${quartermaster::tftpboot}/${distro}/graphics",
        creates => "${quartermaster::tftpboot}/${distro}/graphics/${name}${bootsplash}",
        require =>  [ Class['quartermaster::squid_deb_proxy'], File[ "${quartermaster::tftpboot}/${distro}/graphics" ]],
     }
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
  
  if ! defined (Tftp::File["${distro}/menu/${name}.graphics.conf"]){
    tftp::file  { "${distro}/menu/${name}.graphics.conf":
      ensure  => file,
      require => Tftp::File[ "${distro}/menu" ],
      content => template("quartermaster/pxemenu/${linux_installer}.graphics.erb"),
    }
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
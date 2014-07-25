define quartermaster::pxe::file (
  $arp_type               = $quartermaster::params::arp_type,
  $host_macaddress        = $quartermaster::params::host_macaddress,
  $default_pxeboot_option = $quartermaster::params::default_pxe_option
) {
  tftp::file { "/pxelinux/pxelinux.cfg/${arp_type}-${host_macaddress}":
    ensure  => directory,
    owner   => 'nobody',
    group   => 'nogroup',
    content => template('quartermaster/pxefile.erb')
  }

}

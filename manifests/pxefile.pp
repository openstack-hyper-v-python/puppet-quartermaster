define quartermaster::pxefile (
  $arp_type = '01',
  $host_macaddress = regsubst($macaddress, '(\:)','-','G'),
){
  tftp::file { "pxelinux/pxelinux.cfg/${arp_type}-${host_macaddress}":
    ensure  => directory,
    owner   => 'nobody',
    group   => 'nogroup',
    mode    => $quartermaster::dir_mode,
    require => [ Class[ 'tftp' ],File[ tftpd_config ]],
  }
}

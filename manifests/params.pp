class quartermaster::params {
  $arp_type               = '01'
  $host_macaddress        = regsubst($macaddress, '(\:)','-','G')
  $default_pxeboot_option = 'menu.c32'
  $tmp                    = '/tmp'
  $port                   = 80
  $logroot                = '/var/log/quartermaster'
  $tftpboot               = '/srv/quartermaster/tftpboot'
  $wwwroot                = '/srv/quartermaster/install'
  $nfsroot                = '/srv/quartermaster/nfs'
  $bin                    = "${wwwroot}/bin"
  $puppetmaster_fqdn      = "${fqdn}"
  $exe_mode               = '0777'
  $file_mode              = '0644'
  $dir_mode               = '0755'
  $counter                = '0'
  $nameserver             = '4.2.2.2'
}

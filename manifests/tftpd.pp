# Class: quartermaster::tftpd
#
# Installs and configures tftpd-hpa for use by pxe
# Also handles naming rules for winpe pxeboot environment
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# }
#

class quartermaster::tftpd {

  file { "${quartermaster::tftpboot}":
    owner   => 'tftp',
    group   => 'tftp',
    mode    => $quartermaster::dir_mode,
    ensure  => directory,
  }

  notify {'Creating tftp.rules file to support booting WinPE':}
  file { 'tftpd_rules':
    path     => '/etc/default/tftpd.rules',
    content  => template('quartermaster/winpe/tftp-remap.erb'),
  }

  class{ 'tftp':
     inetd     => false,
     directory => "${quartermaster::tftpboot}",
     options   => '-vvvvs -c -m /etc/default/tftpd.rules',
     require   => [ File[ 'tftpd_rules' ], ],
  }
  
  tftp::file { "menu":
    ensure  => directory,
  }
  
  tftp::file { "pxelinux":
    ensure  => directory,
  }
  
  tftp::file { "pxelinux/pxelinux.cfg":
    ensure  => directory,
    owner   => 'nobody',
    group   => 'nogroup',
  }

}

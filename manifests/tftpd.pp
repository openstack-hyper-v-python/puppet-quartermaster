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
     ensure => directory,
   }

  class{ 'tftp':
     directory => "${quartermaster::tftpboot}",
     options   => '-vvvvs -c -m /etc/default/tftpd.rules',
  }

  notify {'Creating tftp.rules file to support booting WinPE':}
  tftp::file { '/etc/default/tftpd.rules':
    content  => template('quartermaster/winpe/tftp-remap.erb'),
    notify   => Service[ 'tftpd-hpa' ],
    require  => Package[ 'tftpd-hpa' ],
  }

  tftp::file { "${quartermaster::tftpboot}":
    ensure  => directory,
  }
  
  tftp::file { "${quartermaster::tftpboot}/menu":
    ensure  => directory,
  }
  
  tftp::file { "${quartermaster::tftpboot}/pxelinux":
    ensure  => directory,
  }
  
  tftp::file { "${quartermaster::tftpboot}/pxelinux/pxelinux.cfg":
    ensure  => directory,
    owner   => 'nobody',
    group   => 'nogroup',
  }

}

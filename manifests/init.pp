# Class: quartermaster
#
# This module manages quartermaster
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
# Example: Usage at Node.
# node foo {
#    class{quartermaster: }:
#    quartermaster::pxe{"fedora-17-x86_64":}
#    quartermaster::pxe{"fedora-16-i386":}
#    quartermaster::pxe{"ubuntu-12.04-amd64":}
#    quartermaster::pxe{"ubuntu-12.10-amd64":}
#    quartermaster::pxe{"centos-6.3-x86_64":}
#    quartermaster::pxe{"scientificlinux-6.3-x86_64":}
#    quartermaster::pxe{"opensuse-12.2-x86_64":}
#    quartermaster::pxe{"debian-stable-amd64":}
#    quartermaster::windowsmedia{"en_windows_server_2012_x64_dvd_915478.iso": activationkey => "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX" }
#    quartermaster::windowsmedia{"en_microsoft_hyper-v_server_2012_x64_dvd_915600.iso": activationkey => "" }
#    quartermaster::windowsmedia{"en_windows_8_enterprise_x64_dvd_917522.iso": activationkey => "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"}
#    quartermaster::windowsmedia{"en_windows_8_enterprise_x86_dvd_917587.iso": activationkey => "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"}
# }
#

class quartermaster (
  $tmp               = $quartermaster::params::tmp,
  $port              = $quartermaster::params::port,
  $logroot           = $quartermaster::params::logroot,
  $tftpboot          = $quartermaster::params::tftpboot,
  $wwwroot           = $quartermaster::params::wwwroot,
  $nfsroot           = $quartermaster::params::nfsroot,
  $bin               = $quartermaster::params::bin,
  $puppetmaster_fqdn = $quartermaster::params::puppetmaster_fqdn,
  $exe_mode          = $quartermaster::params::exe_mode,
  $file_mode         = $quartermaster::params::file_mode,
  $dir_mode          = $quartermaster::params::dir_mode,
  $counter           = $quartermaster::params::counter,
  $nameserver        = $quartermaster::params::nameserver,
) inherits quartermaster::params {
  # load the image date from hiera
  $linux = hiera('linux',{})
  $windows = hiera('windows',{})

  class{'apt':}
  class { 'quartermaster::commands': }
  class { 'quartermaster::www': }
  class { 'quartermaster::puppetmaster': }
  class { 'quartermaster::squid_deb_proxy': }
  class { 'quartermaster::dnsmasq': }
  class { 'quartermaster::tftpd': }
  class { 'quartermaster::syslinux': }
  class { 'quartermaster::nfs': }
  class { 'quartermaster::winpe': }
  class { 'quartermaster::scripts': }

  quartermaster::pxe{$linux:}
  create_resources(quartermaster::windowsmedia,$windows)
}

class quartermaster::puppetmaster {
  class {'puppet::master':
    autosign     => true,
    parser       => 'future',
  } 
  
  file  {'/etc/puppet/files':
    ensure => directory,
    require => Class['puppet::master'],
  }

  file {'/etc/puppet/fileserver.conf':
    ensure  => file,
    require => Class['puppet::master'],
    source  => "puppet:///modules/quartermaster/puppetmaster/fileserver.conf",
    notify  => Service['apache2'],
  }
}

# Class: quartermaster::www
#
# This Class defines apache::vhosts on the quartermaster node
#
#

class quartermaster::www {
  include 'apache'
  apache::vhost {'quartermaster':
    priority   => '10',
    vhost_name => $::ipaddress,
    port       => $quartermaster::port,
    docroot    => $quartermaster::wwwroot,
    logroot    => $quartermaster::logroot,
  }
}

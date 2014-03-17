echo '### INSTALLING PUPPETLABS APT REPO ###'
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb; dpkg -i puppetlabs-release-precise.deb


echo '### UPDATING AND INSTALLING NECESSARY PACKAGES ###'
apt-get update -y && apt-get install -y openssh-server git puppet ruby1.9.1 ruby1.9.1-dev rubygems

echo "### INSTALLING Q's PUPPETFILE INTO /etc/puppet ###"
wget https://raw.github.com/openstack-hyper-v/puppet-quartermaster/master/Puppetfile -O /etc/puppet/Puppetfile

echo "### INSTALLING  LIBRARIAN-PUPPET DUE TO BUGFIXES IN LIBRARIAN-PUPPET ###"
gem install r10k

echo "### RUNNING LIBRARIAN_PUPPET ###"
cd /etc/puppet && r10k --verbose DEBUG puppetfile install

#Setting Minimal hiera for QuarterMaster
cp -R /etc/puppet/modules/quartermaster/files/hiera /etc/puppet/hiera
echo "creating symlink for from ./hiera.yaml to /etc/puppet/hiera.yaml"
ln -s /etc/puppet/hiera/hiera.yaml /etc/puppet/hiera.yaml

echo "### BOOTSTRAPPING QUARTERMASTER ###"
puppet apply --verbose --trace --debug --modulepath=/etc/puppet/modules /etc/puppet/modules/quartermaster/tests/init.pp
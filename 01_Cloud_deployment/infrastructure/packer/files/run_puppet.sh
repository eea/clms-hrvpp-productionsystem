#!/bin/bash -e
run_puppet_times=$PUPPET_RUN_TIMES
if test -z $run_puppet_times; then run_puppet_times=1; fi

# First go to / as otherwise some paths are not found
cd /

# Derive the puppet_environment from the FACTER_puppet_package parameter
puppet_environment=$( echo "$FACTER_puppet_package" | sed 's/^puppet-//g' )
echo "Setting puppet_environment to: ${puppet_environment}"

# Start with setting up the puppet env
# Using puppet here to install the packages so it can use latest
# that way rebuilding doesn't need an update in the puppet version
# or writing a bash function to figure out what the latest version
# is from artifactory.
echo "Run bootstrap.pp..."
/opt/puppetlabs/bin/puppet apply /tmp/bootstrap.pp
echo "Done!"

# First allow overwriting values from within the included hiera
echo "Patching hierarchy..."
sed '10 i \ - name: "Packer"' /etc/puppetlabs/hieradata/hiera.yaml -i
sed '11 i \   path: "/tmp/packer.yaml"' /etc/puppetlabs/hieradata/hiera.yaml -i
# Remove the vault lookups
sed '50,$d' /etc/puppetlabs/hieradata/hiera.yaml -i
echo "Done!"

# Next patch the puppet.conf file to have the correct environment
echo "Patching puppet.conf..."
sed "s/ENVIRONMENT/${puppet_environment}/g" /tmp/puppet.conf -i
echo "Done!"

# Now run puppet
echo "Running puppet..."
export FACTER_dns_ipaddress=0.0.0.0
for i in $(seq 1 $run_puppet_times); do
/opt/puppetlabs/bin/puppet apply \
  --config=/tmp/puppet.conf \
  "/etc/puppetlabs/code/environments/${puppet_environment}/manifests/_default.pp"
done
echo "Done!"

echo "Starting cleanup..."
echo "Cleanup puppet..."
yum erase -y "$FACTER_puppet_package" "$FACTER_hiera_package" hiera-common puppet-agent puppet5-release
rm -rfv /etc/puppetlabs /etc/facter /opt/puppetlabs

if $( cat /etc/system-release | grep -q 'CentOS' ); then
  echo "Cleanup and setup the upstream centos repos"
  RELEASE_PKG='centos-release'
else
  echo "Cleanup and setup the upstream alma repos"
  RELEASE_PKG='almalinux-release'
fi

yum reinstall -y --downloadonly --downloaddir=/tmp "$RELEASE_PKG"
yum clean all
rm -rf /etc/yum.repos.d/*.repo
rm -rf /var/cache/yum/*
yum reinstall -y /tmp/${RELEASE_PKG}*.rpm

echo "Done!"

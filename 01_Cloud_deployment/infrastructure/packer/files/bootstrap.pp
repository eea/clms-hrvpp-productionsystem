yumrepo { 'vito-yum-puppet':
  ensure   => present,
  baseurl  => "https://artifactory.vgt.vito.be/vito-yum-puppet/",
  descr    => 'vito-yum-puppet',
  gpgcheck => 0,
}

notify { "Installing puppet package: ${::puppet_package}":; }
notify { "Installing hiera package: ${::hiera_package}":; }

package { ['hiera-common', $::hiera_package, $::puppet_package]:
  ensure  => latest,
  require => Yumrepo['vito-yum-puppet'],
}

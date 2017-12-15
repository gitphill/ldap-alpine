# installs software required for development
$settings = loadyaml('/vagrant/settings.yaml')
$versions = $settings[versions]

node default {
  # install ldap client tools
  package {'openldap-clients ':
    ensure => 'installed',
  }
  # install docker
  class { 'docker':
    docker_users => ['vagrant'],
  }
  class { 'docker::compose':
    version => $versions[compose],
    ensure  => present,
  }
}

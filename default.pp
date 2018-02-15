# installs software required for development
$settings = loadyaml('/vagrant/settings.yaml')
$versions = $settings[versions]

node default {

  include stdlib

  # start in /vagrant
  file_line { 'start-dir':
    path => '/home/vagrant/.bashrc',
    line => 'cd /vagrant',
  }

  # install ldap client tools
  package { 'openldap-clients':
    ensure => 'installed',
  }

  # install docker
  class { 'docker':
    docker_users => ['vagrant'],
  }

  # install compose
  class { 'docker::compose':
    version => $versions[compose],
    ensure  => present,
  }

  # alias dc = docker-compose
  file { '/usr/local/bin/dc':
    ensure => 'link',
    target => '/usr/local/bin/docker-compose',
  }

}

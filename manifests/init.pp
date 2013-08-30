class lilurl (
  $user = 'lilurl', 
  $group = 'lilurl', 
  $manage_packages = true,
  $manage_gems = true,
){


  # manage packages

  if $manage_packages {
    $pkgs = ['sqlite3'
             'ruby-sqlite3']
    package { $pkgs:
      ensure => present,
    }
  }

  if $manage_gems {
    $gems = ['rubygems',
             'sinatra',
             'digest-sha1']
    package { $gems:
      ensure   => present,
      provider => 'gem',
    }
  }


  # manage user and group
  group { $group:
    ensure => present,
  }

  user { $user:
    ensure     => present,
    home       => "/home/${user}",
    shell      => '/bin/bash',
    managehome => true,
    gid        => $group,
    require    => Group[$group],
  }


  # manage source
  vcsrepo { "/home/${user}/lilurl":
    ensure   => present,
    provider => git,
    owner    => $user,
    source   => "https://github.com/cmurphy/lilurl.git",
    require  => User[$user],
  }

}

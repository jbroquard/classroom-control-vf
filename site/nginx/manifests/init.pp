class nginx {
  case $::osfamily {
    'redhat','debian': {
      $package = 'nginx'
      $owner   = 'root'
      $group   = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir  = '/var/log/nginx'
    }
    'windows': {
      $package = 'nginx-service'
      $owner   = 'Administrator'
      $group   = 'Administrators'
      $docroot = 'c:/ProgramData/nginx/html'
      $confdir = 'c:/ProgramData/nginx'
      $logdir  = 'c:/ProgramData/nginx/logs'
    }
    default : {
      fail("Module ${module_name} is not intended to run on ${::osfamily}")
    }
  }
  
  $runas_user = $::osfamily ? {
    'redhat'  => 'nginx'
    'debian'  => 'www-data'
    'windows' => 'nobody'
  }
  
  $blockdir = "${confdir}/conf.d"
  
  File {
    owner => "${owner}",
    group => "${group}",
    mode  => '0644',
  }
  
  file { 'nginx rpm' :
    ensure   => file,
    path     => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
    source   => 'puppet:///modules/nginx/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
  }
  
  package { 'nginx' :
    ensure   => '1.6.2-1.el7.centos.ngx',
    source   => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
    provider => rpm,
    require  => File['nginx rpm'],
  }
  
  file { 'doc root':
    ensure => 'directory',
    path   => '/var/www',
  }
  
  file { 'index':
    ensure => 'file',
    path   => '/var/www/index.html',
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { 'nginx base':
    ensure => 'directory',
    path   => '/etc/nginx',
  }
    
  file { 'nginx config':
    ensure  => 'file',
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  
  file { 'default config':
    ensure  => 'file',
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  
  service { 'nginx':
    ensure    => 'running',
    enable    => 'true',
    subscribe => File['nginx config'],
  }
}

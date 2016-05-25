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
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
  }

  File {
    owner => "${owner}",
    group => "${group}",
    mode  => '0644',
  }

  if $::osfamily == 'RedHat' {  
    include centos
    
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
  }
  else {
    package { 'nginx' :
      ensure => present,
    }
  }
  
  file { 'doc root':
    ensure => 'directory',
    path   => "${docroot}",
  }
  
  file { 'index':
    ensure => 'file',
    path   => "${docroot}/index.html",
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { 'nginx base':
    ensure => 'directory',
    path   => "${confdir}",
  }
    
  file { 'nginx config':
    ensure  => 'file',
    path    => "${confdir}/nginx.conf",
    content => template('nginx/nginx.conf.erb'), 
  }
  
  file { 'default config':
    ensure  => 'file',
    path    => "${confdir}/conf.d/default.conf",
    content => template('nginx/default.conf.erb'),
  }
  
  service { 'nginx':
    ensure    => 'running',
    enable    => 'true',
    require   => File['index'], 
    subscribe => [ File['nginx conf'], File['default conf'] ],
  }
}

class nginx {
  package { ['openssl', 'openssl-libs' ]:
    ensure => '1.0.1e-51.el7_2.5',
    before => Package['nginx'],
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
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { 'nginx base':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
    
  file { 'nginx config':
    ensure  => 'file',
    path    => '/etc/nginx/nginx.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
  }
  
  service { 'nginx':
    ensure    => 'running',
    enable    => 'true',
    subscribe => File['nginx config'],
  }
}

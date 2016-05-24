class nginx {
  package { 'nginx':
    ensure => 'present',
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

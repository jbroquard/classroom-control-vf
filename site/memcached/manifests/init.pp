package { 'memcached':
  ensure => 'present',
}

file { '/etc/sysconfig/memcached':
  ensure  => 'file',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => 'puppet:///modules/memcached/memcached',
  require => Package['ntp'],
  notify  => Service['memcached'],
  
}

service { 'memcached':
  ensure => 'running',
  enable => true,
}

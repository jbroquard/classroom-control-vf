class skeleton {
  file { '/etc/skel' :
    ensure => 'directory',
  }

  file { 'bashrc' :
    ensure => 'file',
    path   => '/etc/skel/.bashrc',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/skeleton/bashrc',
  }
}

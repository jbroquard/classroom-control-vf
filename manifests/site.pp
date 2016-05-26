## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node jbroquard.puppetlabs.vm {
  
  if $::virtual {
    $virtual = upcase($::virtual)
    notify { "This is a virtual machine: ${virtual}": }
  }
  
  include users
  include skeleton
  include memcached
  
  #include nginx
  class { 'nginx':
    root => '/var/www/html',
  }
  
  #  file {'motd':
  #    ensure  => file,
  #    path    => '/etc/motd',
  #    owner   => 'root',
  #    group   => 'root',
  #    mode    => '0644',
  #    content => "Lunch is important!\n Eat at Joes!\n",
  #  }

  # Lab 14.1 begin  
  user { 'admin':
    ensure => present,
  }

  class { 'aliases':
    admin   => 'fundamentals',
    require => User['fundamentals'],
  }
  # Lab 14.1 end

  # Lab 15.1 begin
  include users::admins
  # Lab 15.1 end
  
  exec {'motd':
    path    => '/usr/bin:/usr/local/bin',
    command => "cowsay 'Welcome to ${::fqdn}!' > /etc/motd",
    creates => '/etc/motd',
  }
  
  host {'testing':
    name   => 'testing.puppetlabs.vm',
    ensure => 'present',
    ip     => '127.0.0.1',
  }
  
  # Lab 17.1 begin
  $message = hiera('message')
  notify { $message: }
  #Lab 17.1 end
}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  notify { "Hello, my name is ${::hostname}": }
}
  

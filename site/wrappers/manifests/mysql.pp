class wrappers::mysql {
  class { '::mysql::server':
    root_password           => '!My$QL',
    remove_default_accounts => true,
    override_options        => $override_options
  }
}

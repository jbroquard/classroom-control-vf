class roles::sf_wp_blog {
  include profiles::mysql
  include profiles::apache
  include profiles::php
  include profiles::wordpress
}

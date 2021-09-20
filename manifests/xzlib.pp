class xampl::xzlib {

  package { 'ruby-xz':
    ensure   => present,
    provider => puppet_gem,

    # If a custom RubyGem repository needs to be used (such as an internal
    # mirror, or corporate Artifactory repo), pass it with `source`. See:
    # https://puppet.com/docs/puppet/7/types/package.html#package-provider-gem
    source   => 'https://rubygems.org',
  }

}

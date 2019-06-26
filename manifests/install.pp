# A demonstration private class
#
# @summary Demonstrates assert_private()
#
# @exampl
#   include xampl::install
class xampl::install {
  assert_private()

  # The assert_private() function prevents this class from being included
  # externally. It must come from one of the public xampl classes, which can be
  # disabled when needed because they use the `enabled` parameter pattern.

  notify { 'xampl::install class notification':
    message => 'this is a resource',
  }

  xampl::reboot { 'foo':
    when => 'refreshed',
  }

}

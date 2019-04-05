# A demonstration private class
#
# @summary Demonstrates assert_private()
#
# @example
#   include vale::install
class vale::install {
  assert_private()

  # The assert_private() function prevents this class from being included
  # externally. It must come from one of the public vale classes, which can be
  # disabled when needed because they use the `enabled` parameter pattern.

  notify { 'vale::install class notification':
    message => 'this is a resource',
  }

}

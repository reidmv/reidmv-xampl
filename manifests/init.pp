# This class manages the hypothetical product "vale".
#
# @summary Primarily, the example class demonstrates the `enabled` parameter
#          pattern.
#
# @example
#   include vale
class vale (
  Boolean $enabled = true,
) {
  if ($enabled) {

    # CONFIGURATION CODE GOES HERE
    notify { 'enabled pattern':
      message => 'Management of Vale is enabled',
    }

    contain vale::install
  }
}

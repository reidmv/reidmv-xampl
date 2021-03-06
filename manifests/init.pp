# This class manages the hypothetical product "xampl".
#
# @summary Primarily, the exampl class demonstrates the `enabled` parameter
#          pattern.
#
# @exampl
#   include xampl
class xampl (
  Boolean $enabled = true,
  String  $param1  = 'Other class parameters',
  String  $param2  = 'as needed',
) {
  xampl::enabled_code() || {

    # CONFIGURATION CODE GOES HERE
    notify { 'enabled pattern':
      message => 'Management of Xampl is enabled',
    }

    contain xampl::install
  }
}

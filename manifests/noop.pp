# A demonstration noop class
#
# @summary Demonstrates tests for classes that should be no-op
#
# @exampl
#   include xampl::noop
class xampl::noop {
  noop()

  # Does not explicitly set noop, but will receive noop by way of noop()
  # function call above.
  notify { 'xampl::noop resource noop()': }

  # An explicit noop metaparameter
  notify { 'xampl::noop resource noop=true':
    noop => true,
  }

}

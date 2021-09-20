require 'puppet'

# This defines the Puppet feature :xzlib as being true if the ruby-xz gem
# (`require "xz"` library) is present. We will use this feature to confine
# different fact resolutions.
Puppet.features.add(:xzlib, :libs => ['xz'])

# This resolution will be used if the xzlib feature (xz gem) is present.
Facter.add(:xzlib) do
  confine { Puppet.features.xzlib? }

  setcode do
    { 'installed' => true,
      'version'   => FacterXZ.version }
  end
end

# This resolution will be used if the xzlib feature (xz gem) is absent.
Facter.add(:xzlib) do
  confine { !Puppet.features.xzlib? }

  setcode do
    { 'installed' => false }
  end
end

# This resolution will be used if another fact is set, enabling it.  The more
# confine statements a resolution has, the higher its weight. Facter will
# choose which suitable resolution to use based on weight. Because all other
# resolutions only have one confine, and this one has two, it will be used if
# it is suitable.
#
# Example usage:
#   FACTER_xzlib_method=exec facter xzlib
Facter.add(:xzlib) do
  confine { Puppet.features.xzlib? }
  confine :xzlib_method => 'exec'

  setcode do
    { 'installed' => true }
      'version'   => FacterXZ.exec('--version') }
  end
end

# If complex methods, variables, and actions are required, DO NOT leave them in
# the global namespace. For most facts, the code should be written in the
# `setcode { }` blocks of the fact resolutions themselves.
#
# For complex code, at a minimum put the logic into a class or module. The fact
# resolutions above can call methods on the class/module.
#
# Exceptionally complex facts requiring more than that are beyond the scope of
# this example.
module FacterXZ
  extend self

  def version
    XZ::VERSION
  end

  def exec(args)
    # If executing shell commands in custom fact code, use
    # Facter::Core::Execution.execute.
    Facter::Core::Execution.execute("xz #{args}")
  end
end

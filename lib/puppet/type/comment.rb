# This code adds a new metaparameter to all Puppet resources. The "comment"
# metaparameter does not affect any functional aspect of a resource.
Puppet::Type.newmetaparam(:comment) do
   desc "A user-supplied comment about this resource. The comment is non-operative,
      but will be visible in the node's catalog and can be queried for reporting
      purposes."
end

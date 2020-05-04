Puppet::Functions.create_function(:'xampl::enable_comment_metaparam') do
  dispatch :comment do
    # No parameters
  end

  def comment
    Puppet::Type.newmetaparam(:comment) do
       desc "A user-supplied comment about this resource. The comment is non-operative,
          but will be visible in the node's catalog and can be queried for reporting
          purposes."
    end
  end
end

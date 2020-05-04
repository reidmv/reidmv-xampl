Puppet::Functions.create_function(:'xampl::internal::load_comment_metaparam') do
  dispatch :load_comment do
    # No parameters
  end

  def load_comment
    unless Puppet::Type.metaparam?(:comment)
      Puppet::Type.newmetaparam(:comment) do
         desc "A user-supplied comment about this resource. The comment is non-operative,
            but will be visible in the node's catalog and can be queried for reporting
            purposes."
      end
    end

    'load-content-metaparam'
  end
end

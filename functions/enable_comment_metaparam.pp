function xampl::enable_comment_metaparam() {

  # Load the metaparam on the master
  xampl::internal::load_comment_metaparam()

  # Ensure the metaparam is loaded on the agent
  anchor { 'load-comment-metaparam':
    name => Deferred('xampl::internal::load_comment_metaparam', []),
  }
}

Puppet::Functions.create_function(:'xampl::enabled_code', Puppet::Functions::InternalFunction) do
  dispatch :auto_enabled_code do
    scope_param
    required_block_param
  end

  dispatch :enabled_code do
    scope_param
    param 'Boolean', :enabled
    required_block_param
  end

  def auto_enabled_code(scope, &block)
    if scope.has_local_variable?('enabled') && [true, false].include?(scope['enabled'])
      enabled_code(scope, scope['enabled'], &block)
    else
      raise "Unable to implement xampl::enabled_code(). Class must define specific parameter:\n" \
            "  class example (\n" \
            "    Boolean $enabled = true,\n" \
            "    ...\n" \
            "  ) {\n" \
            "    xampl::enabled_code() || {\n" \
            "      ...\n" \
            "    }\n" \
            "  }\n"
    end
  end

  def enabled_code(scope, enabled, &block)
    case enabled
    when true
      yield
    else
      scope.resource.tag('disabled')
    end
  end
end

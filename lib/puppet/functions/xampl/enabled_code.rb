Puppet::Functions.create_function(:'xampl::enabled_code', Puppet::Functions::InternalFunction) do
  dispatch :enabled_code do
    scope_param
    param 'Boolean', :enabled
    required_block_param
  end

  def enabled_code(scope, enabled)
    case enabled
    when true
      yield
    else
      scope.resource.tag('disabled')
    end
  end
end

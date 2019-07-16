require 'spec_helper'

describe 'xampl::noop' do
  it_behaves_like 'a no-op includable class'
  it_behaves_like 'a policy-compliant class'
end

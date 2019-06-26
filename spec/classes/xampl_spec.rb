require 'spec_helper'

describe 'xampl' do
  it_behaves_like 'an enableable class'
  it_behaves_like 'an includable class'
  it_behaves_like 'a policy-compliant class'
end

require 'spec_helper'

describe 'xampl::install' do
  context 'When included from an external module' do
    it { is_expected.to compile.and_raise_error %r{is private} }
  end

  context 'When included from the xampl module' do
    let(:pre_condition) do
      # This mocks the assert_private() function so that the class may be tested
      'function assert_private() { }'
    end

    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile }
      end
    end
  end
end

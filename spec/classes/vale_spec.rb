require 'spec_helper'

describe 'vale' do

  context 'When disabled' do
    let(:params) do
      {
        enabled: false
      }
    end

    it 'should not contribute any resources to the catalog' do
      contributed_resources = catalogue.resources
                              .reject { |r| r.type == 'Class' }
                              .select { |r| r.tags.include?('vale') }

      expect(contributed_resources).to eq([])
    end
  end

  context 'When enabled' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile }
      end
    end
  end
end

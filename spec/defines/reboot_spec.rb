require 'spec_helper'

describe 'xampl::reboot' do
  let(:title) { 'spec-reboot' }
  let(:params) do
    {}
  end

  context 'when $facts[allow_reboot] == true' do
    let(:facts) do
      { 'allow_reboot' => true }
    end

    it { is_expected.to contain_reboot('spec-reboot').without_noop }
  end

  context 'when $facts[allow_reboot] == true but the noop parameter is set to true' do
    let(:facts) do
      { 'allow_reboot' => true }
    end
  let(:params) do
    { 'noop' => true }
  end

    it { is_expected.to contain_reboot('spec-reboot').with_noop(true) }
  end

  context 'when $facts[allow_reboot] == false' do
    let(:facts) do
      { 'allow_reboot' => false }
    end

    it { is_expected.to contain_reboot('spec-reboot').with_noop(true) }
  end

  context 'when $facts[allow_reboot] == false but the noop parameter is set to false' do
    let(:facts) do
      { 'allow_reboot' => false }
    end
  let(:params) do
    { 'noop' => false }
  end

    it { is_expected.to contain_reboot('spec-reboot').with_noop(true) }
  end

  context 'when $facts[allow_reboot] is not set' do
    let(:facts) do
      {}
    end

    it { is_expected.to contain_reboot('spec-reboot').with_noop(true) }
  end
end

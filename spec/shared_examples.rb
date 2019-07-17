# Throw this block in `spec/spec_helper_local.rb` if you're using PDK so that
# it is available everywhere.

def contained_by?(resource, container, catalog)
  container_of = catalog.container_of(resource)
  case container_of
  when nil
    false
  when container
    true
  else
    contained_by?(container_of, container, catalog)
  end
end

RSpec.shared_examples 'a policy-compliant class' do
  let(:pre_condition) do
    # This mocks the assert_private() function so that private classes may be tested
    'function assert_private() { }'
  end

  include_examples 'a class without unprotected reboots'
end

RSpec.shared_examples 'a class without unprotected reboots' do
  subject(:reboot_resources) do
    catalogue.resources.select { |r| r.type == 'Reboot' }
  end

  it 'does not have any unprotected reboot resources' do
    expect(reboot_resources).to all(satisfy do |r1|
      catalogue.resources.find { |r2| r2.type == 'Xampl::Reboot' && r2.title == r1.title }
    end)
  end
end

RSpec.shared_examples 'an enableable class' do |parameters = {}|
  context 'When disabled' do
    let(:params) do
      parameters.merge(enabled: false)
    end

    it 'is tagged "disabled"' do
      class_tags = catalogue.resources
                            .find { |r| r.type == 'Class' && r.title.downcase == class_name }
                            .tags
                            .to_a

      expect(class_tags).to include('disabled')
    end

    it 'does not contribute any resources to the catalog' do
      contributed_resources = catalogue.resources
                                       .reject { |r| r.type == 'Class' }
                                       .select { |r| r.tags.include?(class_name) }

      expect(contributed_resources).to eq([])
    end
  end
end

RSpec.shared_examples 'an includable class' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end

RSpec.shared_examples 'a no-op class' do
  it 'sets all resources contained in the class to no-op' do
    container = catalogue.resources.find { |r| r.class? && class_name.casecmp(r.title.to_s).zero? }
    op_resources = catalogue.resources
                            .select { |r| contained_by?(r, container, catalogue) }
                            .reject { |r| r[:noop] == true }
                            .map { |r| r.ref } # For clarity in output

    expect(op_resources).to eq([])
  end
end

RSpec.shared_examples 'a no-op includable class' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      include_examples 'a no-op class'
    end
  end
end

RSpec.shared_examples 'a private class' do |pre_condition = ''|
  context 'When included from an external module' do
    it { is_expected.to compile.and_raise_error %r{is private} }
  end

  context 'When included from this module' do
    let(:pre_condition) do
      [
        # This mocks the assert_private() function so that the class may be tested
        'function assert_private() { }',
        pre_condition,
      ].join("\n")
    end

    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile }
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe Karafka do
  describe 'batched group' do
    let(:group) do
      described_class::App.consumer_groups.find do |cg|
        cg.name == 'batched_group'
      end
    end

    describe 'text_image.created topic' do
      let(:topic) { group.topics.find('textimage_created') }

      it { expect(topic).to be_a Karafka::Routing::Topic }
    end
  end
end

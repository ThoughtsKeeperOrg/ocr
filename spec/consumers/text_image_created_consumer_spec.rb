# frozen_string_literal: true

RSpec.describe TextImageCreatedConsumer do
  subject(:consumer) { karafka.consumer_for(:textimage_created) }

  let(:payload) do
    {
      'file_path' => 'some/path/to/file/img.jpg',
      'filename' => 'img.jpg'
    }
  end

  before do
    karafka.produce(payload.to_json)
    allow(Karafka.logger).to receive(:info)
  end

  it 'expects to log a proper message' do
    expect(Karafka.logger).to receive(:info).with(payload)
    consumer.consume
  end
end

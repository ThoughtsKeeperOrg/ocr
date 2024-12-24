# frozen_string_literal: true

# This consumer receives a batch of messages at once
# You can use it to process multiple messages at  the same time, for example
# for batch inserting ito database, etc
# The batch is accessible using the #messages method
class TextImageCreatedConsumer < ApplicationConsumer
  def consume

      p '@'*88

    messages.each do |message|
      p message.payload
      p message
      p message.key
      Karafka.logger.info message.payload

      text =  RTesseract.new(message.payload['file_path'], lang:'eng+ukr+deu').to_s
      Karafka.producer
               .produce_sync(key: message.key,
                             topic: :ocr,
                             payload: { status: 'scanned',
                                        text: text }.to_json)
      # Thought.create(content: message.payload.to_json)
    rescue StandardError => e
      p '*' * 88
      p e.message
      p e.backtrace.join("\n")
      p '*' * 88
    end
  end
end

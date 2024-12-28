# frozen_string_literal: true

class TextImageCreatedConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Karafka.logger.info message.payload
      text =  RTesseract.new(message.payload['file_path'], lang:'eng+ukr+deu').to_s
      Karafka.producer
               .produce_sync(key: message.key,
                             topic: :ocr,
                             payload: { status: 'scanned',
                                        text: text }.to_json)
    rescue StandardError => e
      p '*' * 88
      p e.message
      p e.backtrace.join("\n")
      p '*' * 88
    end
  end
end

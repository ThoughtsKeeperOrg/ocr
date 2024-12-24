# frozen_string_literal: true

# This consumer receives a batch of messages at once
# You can use it to process multiple messages at  the same time, for example
# for batch inserting ito database, etc
# The batch is accessible using the #messages method
class TextImageCreatedConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Karafka.logger.info message.payload
      # Thought.create(content: message.payload.to_json)
    rescue StandardError => e
      Karafka.logger.debug '*' * 88
      Karafka.logger.debug e.message
      Karafka.logger.debug e.backtrace.join("\n")
      Karafka.logger.debug '*' * 88
    end
  end
end

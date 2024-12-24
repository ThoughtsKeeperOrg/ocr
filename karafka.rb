# frozen_string_literal: true

# This is a non-Rails example app!

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new

%w[
  lib
  app/consumers
].each(&APP_LOADER.method(:push_dir))

APP_LOADER.setup
APP_LOADER.eager_load

# App class
class App < Karafka::App
  setup do |config|
    config.concurrency = 5
    config.kafka = { 'bootstrap.servers': ENV.fetch('KAFKA_SOCKET', 'localhost:9092') }
    config.client_id = ENV.fetch('KAFKA_CLIENT_ID', 'ocr_service')
  end
end

Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)
Karafka.producer.monitor.subscribe(
  WaterDrop::Instrumentation::LoggerListener.new(
    Karafka.logger,
    # If you set this to true, logs will contain each message details
    # Please note, that this can be extensive
    log_messages: false
  )
)

App.consumer_groups.draw do
  consumer_group :batched_group do
    topic :textimage_created do

      p '!'*88
      config(partitions: 1)
      consumer TextImageCreatedConsumer
    end
  end
end

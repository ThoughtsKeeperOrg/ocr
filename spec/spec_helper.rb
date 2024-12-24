# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV['KARAFKA_ENV'] ||= 'test'

%w[
  rubygems
  rake
  logger
  ostruct
  karafka
  karafka/testing/rspec/helpers
].each(&method(:require))

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  config.include Karafka::Testing::RSpec::Helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

require './karafka'

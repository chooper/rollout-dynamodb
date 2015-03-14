require "rubygems"
require "bundler"

Bundler.require(:default, :development)


require "rollout/dynamodb/storage"
require "rollout"
require "webmock/rspec"
require "rspec"
require "bourne"

def dynamodb_configured?
  [
    ENV['TEST_DYNAMO_ACCESS_KEY'],
    ENV['TEST_DYNAMO_SECRET_KEY'],
    ENV['TEST_DYNAMO_TABLE_NAME'],
    ENV['TEST_DYNAMO_REGION'],
  ].all?
end

def clear_table!(storage, table)
  storage.list.map { |item| storage.del(item) }
end

RSpec.configure do |config|
  config.expect_with :rspec, :test_unit
  config.mock_with :mocha
end

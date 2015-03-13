require "rubygems"
require "bundler"

Bundler.require(:default, :development)

require "webmock/rspec"

require "rollout/dynamodb/storage"

def skip_dynamodb_tests?
  ![
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
  config.expect_with :test_unit
end

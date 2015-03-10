require "rubygems"
require "bundler"

Bundler.require(:default, :development)

require "webmock/rspec"

#require "rollout"
require "rollout/dynamodb/storage"

RSpec.configure do |config|
  config.expect_with :test_unit
end

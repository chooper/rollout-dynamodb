#require "rollout/storage/dynamodb"
require "spec_helper"

describe Rollout::DynamoDB do
  before do
    @storage = Rollout::DynamoDB::Storage.new("access-key", "secret-key", "table", "us-east-99")
    @rollout = Rollout.new(@storage)

    @dynamo_url = "https://dynamodb.us-east-99.amazonaws.com/"
  end

  describe "#get" do
    it "returns valid data when key exists" do
      stub_request(:post, @dynamo_url).
        to_return(:body => "{\"ConsumedCapacityUnits\":0.5,\"Item\":{\"value\":{\"S\":\"my-value\"},\"id\":{\"S\":\"my-key\"}}}")

      value = @storage.get("my-key")
      assert_requested(:post, @dynamo_url) do |req|
        body = MultiJson.decode(req.body)
        body == {"Key"=>{"HashKeyElement"=>{"S"=>"my-key"}}, "TableName"=>"table"}
      end
      assert_equal value, "my-value"
    end
  end

  describe "#set" do
    it "sends a valid post when called" do
      stub_request(:post, @dynamo_url).
        to_return(:body => "{\"Key\":{\"HashKeyElement\":{\"S\":\"my-key\"}},\"TableName\":\"table\"}")

      response = @storage.set("my-key", "my-value")
      assert_requested(:post, @dynamo_url) do |req|
        body = MultiJson.decode(req.body)
        body == {"Item"=>{"id"=>{"S"=>"my-key"}, "value"=>{"S"=>"my-value"}}, "TableName"=>"table"}
      end
    end
  end
  # ...
end


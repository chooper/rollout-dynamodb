#require "rollout/storage/dynamodb"
require "spec_helper"

describe Rollout::DynamoDB do
  before do
    @storage = Rollout::DynamoDB::Storage.new("access-key", "secret-key", "table", "us-east-99")
    @rollout = Rollout.new(@storage)

    @dynamo_url = "https://dynamodb.us-east-99.amazonaws.com/"
  end

  describe "#initialize" do
    it "sets default options" do
      defaults = {
        :connection_options => {
          :connect_timeout  => 3,
          :read_timeout     => 3,
          :write_timeout    => 3,
          :retry_limit      => 4}}

      assert_equal @storage.instance_variable_get(:@options), defaults
    end

    it "sets AWS/DynamoDB instance variables" do
      assert_equal @storage.instance_variable_get(:@aws_access_key), "access-key"
      assert_equal @storage.instance_variable_get(:@aws_secret_key), "secret-key"
      assert_equal @storage.instance_variable_get(:@table_name),     "table"
      assert_equal @storage.instance_variable_get(:@region),         "us-east-99"
    end
  end

  describe "#get" do
    it "sends a valid post and returns valid data when key exists" do
      stub_request(:post, @dynamo_url).
        to_return(:body => "{\"ConsumedCapacityUnits\":0.5,\"Item\":{\"value\":{\"S\":\"my-value\"},\"id\":{\"S\":\"my-key\"}}}")

      value = @storage.get("my-key")
      assert_requested(:post, @dynamo_url) do |req|
        body = MultiJson.decode(req.body)
        body == {"Key"=>{"HashKeyElement"=>{"S"=>"my-key"}}, "TableName"=>"table"}
      end
      assert_equal value, "my-value"
    end

    it "returns valid data when key does not exist" do
      stub_request(:post, @dynamo_url).
        to_return(:body => "{\"ConsumedCapacityUnits\":0.5}")

      value = @storage.get("my-nonexistent-key")
      assert_requested(:post, @dynamo_url) do |req|
        body = MultiJson.decode(req.body)
        body == {"Key"=>{"HashKeyElement"=>{"S"=>"my-nonexistent-key"}}, "TableName"=>"table"}
      end
      assert_nil value
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


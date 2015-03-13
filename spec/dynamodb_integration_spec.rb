require "spec_helper"

describe Rollout::DynamoDB do
  before do
    skip if skip_dynamodb_tests?
    WebMock.allow_net_connect!

    aws_access_key = ENV['TEST_DYNAMO_ACCESS_KEY']
    aws_secret_key = ENV['TEST_DYNAMO_SECRET_KEY']
    aws_table_name = ENV['TEST_DYNAMO_TABLE_NAME']
    aws_region     = ENV['TEST_DYNAMO_REGION']

    @storage = Rollout::DynamoDB::Storage.new(aws_access_key, aws_secret_key, aws_table_name, aws_region)
    clear_table!(@storage, aws_table_name) unless skip_dynamodb_tests?
  end

  describe "DynamoDB integration" do
    it "get works correctly when key doesn't exist" do
      value = @storage.get("my-key")
      assert_nil value
    end

    it "set and get work correctly for new keys" do
      value = @storage.set("my-key", "my-value")
      assert value

      value = @storage.get("my-key")
      assert_equal "my-value", value
    end

    it "set and get work correctly for existing keys" do
      value = @storage.set("my-reused-key", "my-old-value")
      assert value

      value = @storage.set("my-reused-key", "my-new-value")
      assert value

      value = @storage.get("my-reused-key")
      assert_equal "my-new-value", value
    end

    it "delete works on key that doesn't exist" do
      value = @storage.del("my-nonexistent-key")
      assert value
    end

    it "delete works for existing keys" do
      value = @storage.set("my-deleted-key", "delete me")
      assert value

      value = @storage.del("my-deleted-key")
      assert value

      value = @storage.get("my-deleted-key")
      assert_nil value
    end
  end
end

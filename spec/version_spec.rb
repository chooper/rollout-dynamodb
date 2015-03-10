require "spec_helper"

describe Rollout::DynamoDB do
  it "has a VERSION constant set to a string" do
    Rollout::DynamoDB::VERSION.is_a?(String)
  end
end


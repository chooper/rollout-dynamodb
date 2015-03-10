
require 'fog'

module Rollout::DynamoDB
  class Storage
    def initialize(aws_access_key, aws_secret_key, table_name, region, options = {})
      @aws_access_key   = aws_access_key
      @aws_secret_key   = aws_secret_key
      @table_name       = table_name
      @region           = region
      @options          = options

      # timeouts are expressed in seconds
      @options[:connection_options] ||= {}
      @options[:connection_options][:connect_timeout] ||= 3
      @options[:connection_options][:read_timeout]    ||= 3
      @options[:connection_options][:write_timeout]   ||= 3
      @options[:connection_options][:retry_limit]     ||= 4
    end

    def db
      @db ||= Fog::AWS::DynamoDB.new(
        @options.merge(
          :aws_access_key_id => @aws_access_key,
          :aws_secret_access_key => @aws_secret_key,
          :region => @region))
    end

    def get(key)
      response = db.get_item(@table_name, {'HashKeyElement' => {'S' => key}})
      response.body['Item']['value']['S']
    end

    def set(key, value)
      response = db.put_item(@table_name, {'id' => {'S' => key}, 'value' => {'S' => value}})
      response.body
    end

    def del(key)
      response = db.delete_item(@table_name, {'HashKeyElement' => {'S' => key}})
      response.body
    end
  end
end


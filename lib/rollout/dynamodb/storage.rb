
require 'fog'

##
# This module is a container for all things related to Rollout+DynamoDB functionality
module Rollout::DynamoDB

  ##
  # This class implements the Storage API for Rollout
  class Storage

    ##
    # `options` is a Hash which may include:
    # * `:connection_options` - a Hash which may in turn include:
    #    * `:connect_timeout` - Connection timeout to DynamoDB in seconds (default: `3`)
    #    * `:read_timeout`    - Read timeout to DynamoDB in seconds (default: `3`)
    #    * `:write_timeout`   - Write timeout to DynamoDB in seconds (default: `3`)
    #    * `:retry_limit`     - Number of times to retry HTTP requests to DynamoDB (default: `4`)
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

    ##
    # Gets the value (*String*) of a key (*String*) from DynamoDB. Returns the
    # value or raises an exception on error
    def get(key)
      response = db.get_item(@table_name, {'HashKeyElement' => {'S' => key}})
      get_item_from_body(response.body)
    end

    ##
    # Sets the value (*String*) of a key (*String*) in DynamoDB. Returns `true`
    # on success, raises an exception on error
    def set(key, value)
      response = db.put_item(@table_name, {'id' => {'S' => key}, 'value' => {'S' => value}})
      true
    end

    ##
    # Deletes a key (*String*) from DynamoDB. Returns `true` on success or
    # raises an exception on errror
    def del(key)
      response = db.delete_item(@table_name, {'HashKeyElement' => {'S' => key}})
      true
    end

    ##
    # Returns an `Array` of keys (`String`) from DynamoDB. Not used by the
    # Storage API, but provided as a convenience and used in tests.
    def list
      response = db.scan(@table_name)
      response.body['Items'].map { |x| get_key_from_result(x) }
    end

    private

    ##
    # Returns the DynamoDB connection object
    def db
      @db ||= Fog::AWS::DynamoDB.new(
        @options.merge(
          :aws_access_key_id => @aws_access_key,
          :aws_secret_access_key => @aws_secret_key,
          :region => @region))
    end

    ##
    # Extracts and returns a key (*String*) from a DynamoDB result set. May be `nil`.
    def get_key_from_result(res)
      res.fetch('id', {}).fetch('S', nil)
    end

    ##
    # Extracts and returns a value (*String*) from a DynamoDB result set. May be `nil`.
    def get_item_from_result(res)
      res.fetch('value', {}).fetch('S', nil)
    end

    ##
    # Returns an item (*Hash*) from a DynamoDB result body
    def get_item_from_body(body)
      get_item_from_result(body.fetch('Item', {}))
    end
  end
end


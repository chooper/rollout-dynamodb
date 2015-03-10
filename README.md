# DynamoDB storage adapter for Rollout

This is a storage adapter for
[Rollout](https://github.com/FetLife/rollout) that uses DynamoDB.
Rollout allows you to flip feature flags around in a sane way.

I wrote this adapter for those who either don't want to stand up a new
redis instance or introduce a new single point of failure into their
architecture.

[![Build Status](https://travis-ci.org/chooper/rollout-dynamodb.svg?branch=master)](https://travis-ci.org/chooper/rollout-dynamodb)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rollout-dynamodb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rollout-dynamodb

## Usage

```ruby
$storage = Rollout::DynamoDB::Storage.new(aws_access_key, aws_secret_key, aws_table_name, aws_region)
$rollout = Rollout.new($storage)

$rollout.active?(:chat)
# -> false
$rollout.activate(:chat)
# -> {}
$rollout.active?(:chat)
# -> true
```

## Contributing

1. Fork it ( https://github.com/chooper/rollout-dynamodb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


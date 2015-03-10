# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/rollout-dynamodb.rb"

Gem::Specification.new do |spec|
  spec.name          = "rollout-dynamodb"
  spec.version       = Rollout::DynamoDB::VERSION
  spec.authors       = ["Charles Hooper"]
  spec.email         = ["charles@heroku.com"]
  spec.summary       = "DynamoDB adapter for Rollout"
  spec.description   = "DynamoDB adapter for Rollout"
  spec.homepage      = "https://github.com/chooper/rollout-dynamodb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "foreman"
  spec.add_dependency 'rollout', [">= 2.0"] 
  spec.add_dependency "fog"
end
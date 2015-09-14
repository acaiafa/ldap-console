ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'rack/test'
require_relative '../app/boot.rb'

#set stub data
ALLOWED_GROUPS_POWER = ["anthony@example.com"]
ALLOWED_GROUPS_MIN = ["jason@example.com"]

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.color = true
  config.tty = true
  config.order = "random"
end

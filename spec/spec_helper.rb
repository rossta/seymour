# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
# require "rails/test_help"
Rails.backtrace_cleaner.remove_silencers!

# Load support files 
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'
$LOAD_PATH.unshift dir + '/support'

require 'seymour'
require 'test_redis'
require 'factory_girl_rails'

RSpec.configure do |config|
  config.mock_with :rspec
end

TestRedis::Server.start!(dir)
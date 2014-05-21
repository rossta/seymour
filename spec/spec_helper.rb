dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'seymour'
require 'seymour/engine'

require 'rspec/rails'
require "ammeter/init"
require 'factory_girl_rails'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Rails.backtrace_cleaner.remove_silencers!
TestRedis::Server.start!(dir)

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
end


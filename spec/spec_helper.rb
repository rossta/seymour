dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require "ammeter/init"
require 'factory_girl_rails'
require 'database_cleaner'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:suite) do
    unless ENV['CI'] == 'travis'
      TestRedis::Server.start!(dir)
    end
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end


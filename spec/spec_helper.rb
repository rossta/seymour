dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'
$LOAD_PATH.unshift dir + '/support'

require 'seymour'
require 'test_redis'

RSpec.configure do |config|
  config.mock_with :rspec
end

TestRedis::Server.start!(dir)
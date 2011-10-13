dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'seymour'

RSpec.configure do |config|
  config.mock_with :rspec
end

at_exit do
  pid = `ps -A -o pid,command | grep [r]edis-spec`.split(" ")[0]
  puts "Killing test redis server..."
  `rm -f #{dir}/dump.rdb`
  Process.kill("KILL", pid.to_i)
  exit $!.status
end

puts "Starting redis for testing at localhost:9736..."
`redis-server #{dir}/redis-spec.conf`
Seymour.redis = 'localhost:9736'
module TestRedis
  class Server
    def self.start!(dir)
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
    end
  end
end

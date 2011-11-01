module Seymour
  module Redis
    class Zset < Seymour::Redis::Base

      # def zadd(score, member)
      #   redis.zadd(@key, score, member)
      # end
      # 
      # def zrem(member)
      #   redis.zrem(@key, member)
      # end
      # 
      # def zincrby(increment, member)
      #   redis.zincrby(@key, increment, member)
      # end
      # 
      # def zincr(member)
      #   zincrby(1, member)
      # end
      # 
      # def zrange(range_start, range_end)
      #   typecast redis.zrange(@key, range_start, range_end)
      # end
      # 
      # def zrevrange(range_start, range_end)
      #   typecast redis.zrevrange(@key, range_start, range_end)
      # end
      # 
      # def zrangebyscore(min, max)
      #   typecast redis.zrangebyscore(@key, min, max)
      # end
      # 
      # def zcard
      #   redis.zcard(@key)
      # end
      # 
      # def zscore(member)
      #   redis.zscore(@key, member).to_f
      # end
      # 
      # def zremrangebyscore(min, max)
      #   redis.zremrangebyscore(@key, min, max)
      # end
      # 
      # def zremrangebyrank(start, _end)
      #   redis.zremrangebyrank(@key, start, _end)
      # end

    end
  end
end
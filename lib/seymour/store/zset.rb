module Seymour
  module Store
    class Zset < Seymour::Store::Base

      def push(activity, score = activity.score)
        redis.zadd(key, score, activity.id)
      end

      def ids
        redis.zrevrange(key, 0, max_size).map(&:to_i)
      end

      def remove_id(id)
        redis.zrem(key, id)
      end

      def union(feeds)
        options = feeds.extract_options!
        redis.zunionstore key, feeds.map(&:key), options
      end

      # def zadd(score, member)
      #   redis.zadd(@key, score, member)
      # end

      # def zrange(range_start, range_end)
      #   typecast redis.zrange(@key, range_start, range_end)
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
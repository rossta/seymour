module Seymour
  module Redis
    class List < Seymour::Redis::Base

      def ids
        redis.lrange(key, 0, max_size).map(&:to_i)
      end

      def perform_push(id)
        redis.lpush(key, id)
        redis.ltrim(key, 0, max_size)
      end

      def push(activity)
        perform_push(activity.id) if should_push?(activity)
      end

      def bulk_push(activities)
        activities.each do |activity|
          push(activity)
        end
      end

      def remove(activity)
        remove_id activity.id
      end

      def remove_id(id)
        redis.lrem(key, 0, id)
      end

      def remove_all
        redis.del(key)
      end

      def sort!(options = {})
        sort({ :order => "DESC", :store => key }.merge(options)) # replaces itself with sorted list
      end

      def sort(options = {})
        redis.sort(key, options)
      end

      def sorted_push(activities)
        bulk_push(activities)
        sort!
      end
      alias_method :insert_and_order, :sorted_push

      private

      def should_push?(\  )
        !activity_ids.include?(activity.id)
      end

      # def llen
      #   redis.llen(@key)
      # end
      #
      # def rpop
      #   redis.rpop(@key)
      # end
      #
      # def rpoplpush(destination)
      #   if destination.is_a?(RedisList)
      #     redis.rpoplpush(@key, destination.key)
      #     destination.trim_to_max_size
      #   else
      #     redis.rpoplpush(@key, destination)
      #   end
      # end
      #
      # def lpush(val)
      #   redis.lpush(@key, val)
      #   trim_to_max_size
      # end
      #
      # def push_multi(elements)
      #   redis.pipelined do
      #     elements.each { |element| redis.rpush(@key, element) }
      #   end
      # end
      #
      # def lrange(start_index, end_index)
      #   arr = redis.lrange(@key, start_index, end_index)
      #   typecast arr
      # end
      #
      # def all
      #   lrange(0, -1)
      # end
      #
      # def ltrim(start_index, end_index)
      #   redis.ltrim(@key, start_index, end_index)
      # rescue => ex
      #   raise unless ex.message =~ /no such key/
      # end
      #
      # def trim_to_max_size
      #   if max_size
      #     redis.ltrim(@key, 0, max_size - 1)
      #   end
      # end
      #
      # def lrem(value, count = 1)
      #   redis.lrem(@key, count, value)
      # end
      #
      # def max_size
      #   @options[:max_size]
      # end
    end
  end
end
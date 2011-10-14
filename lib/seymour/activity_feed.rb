module Seymour
  class ActivityFeed

    attr_accessor :owner

    class << self
      def distribute
        
      end

      def reset_classes!
        @@feed_classes = []
      end

      def inherited(subclass)
        @@feed_classes << subclass
      end

      def feed_classes
        @@feed_classes
      end

    end
    reset_classes!

    def initialize(owner)
      @owner = owner
    end

    def activity_ids
      redis.lrange(key, 0, max_size).map{|id| id.to_i }
    end

    def push(activity, cmd = :lpush)
      perform_push(activity.id, cmd) if should_push?(activity)
    end

    private

    def redis
      @redis ||= Seymour.redis
    end

    def key
      "#{owner.class.name}:#{id_for_key}/#{feed_name}"
    end

    def id_for_key
      owner.id
    end

    def feed_name
      self.class.name.downcase
    end

    def max_size
      100
    end

    def should_push?(activity)
      true
    end

    def perform_push(activity_id, cmd = :lpush)
      redis.send(cmd, key, activity_id)
      redis.ltrim(key, 0, max_size)
    end

  end
end
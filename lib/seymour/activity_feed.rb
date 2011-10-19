module Seymour
  class ActivityFeed

    attr_accessor :owner

    class << self
      @@feed_classes = []

      def distribute(activity)
        activity.distribute
      end

      def inherited(subclass)
        @@feed_classes << subclass
      end

      def feed_classes
        @@feed_classes
      end
    end

    def initialize(owner)
      @owner = owner
    end

    def activity_ids
      redis.lrange(key, 0, max_size).map{|id| id.to_i }
    end

    def push(activity, cmd = :lpush)
      perform_push(activity.id, cmd) if should_push?(activity)
    end

    def remove(activity)
      remove_id activity.id
    end

    def remove_id(activity_id)
      redis.lrem(key, 0, activity_id)
    end

    private

    def redis
      @redis ||= Seymour.redis
    end

    def owner_name
      owner.class.name
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
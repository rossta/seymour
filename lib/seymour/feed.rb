module Seymour
  class Feed

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

      def key(&block)
        define_method('key', &block)
      end
    end

    def initialize(owner)
      @owner = owner
    end

    def activity_ids
      redis.lrange(key, 0, max_size).map{|id| id.to_i }
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

    def remove_id(activity_id)
      redis.lrem(key, 0, activity_id)
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

    def key
      "#{owner.class.name}:#{id_for_key}/#{feed_name}"
    end

    protected

    def redis
      @redis ||= Seymour.redis
    end

    def remove_all
      redis.del(key)
    end

    def owner_name
      owner.class.name
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
      !activity_ids.include?(activity.id)
    end

    def perform_push(id)
      redis.lpush(key, id)
      redis.ltrim(key, 0, max_size)
    end
  end
end

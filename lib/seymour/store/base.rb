module Seymour
  module Store
    class Base
      attr_accessor :key

      def initialize(key, options = {})
        @key = key
        @options = options
      end

      def redis
        @redis ||= Seymour.redis
      end

      def activity_ids
        ids
      end

      def max_size
        100
      end

      def bulk_push(activities)
        activities.each do |activity|
          push(activity)
        end
      end

      def remove(activity)
        remove_id(activity.id)
      end

    end
  end
end
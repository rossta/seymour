module Seymour
  module Redis
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

    end
  end
end
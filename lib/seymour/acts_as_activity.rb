module Seymour

  module ActsAsActivity
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_activity
        warn "acts_as_activity is now deprecated. Use `include Seymour::HasAudience` instead."
        include Distributable
        include Renderable
        yield self if block_given?
      end

      def feed_me_seymour
        warn "feed_me_seymour is now deprecated. Use `include Seymour::HasAudience` instead."
        include Distributable
        include Renderable
        yield self if block_given?
      end
    end

  end
end

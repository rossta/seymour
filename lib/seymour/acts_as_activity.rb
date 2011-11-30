module Seymour

  module ActsAsActivity
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_activity
        include Distributable
        include Renderable
        yield self if block_given?
      end
      alias_method :feed_me_seymour, :acts_as_activity
    end

  end
end

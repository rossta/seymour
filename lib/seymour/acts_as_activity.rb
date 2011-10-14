module Seymour

  module ActsAsActivity
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def acts_as_activity
        class << self
          attr_accessor :destination_feeds

          def feed(listener, opts = {})
            feed_class = (opts[:class_name] || "#{listener}_feed".camelize).constantize
            destination_feeds << feed_class
          end

          def destination_feeds
            @destination_feeds ||= []
          end

        end

        yield self if block_given?
      end

    end

  end
end

ActiveRecord::Base.send :include, Seymour::ActsAsActivity
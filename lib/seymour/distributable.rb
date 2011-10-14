module Seymour

  module Distributable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      mattr_accessor :feed_classes

      def feed(listener, opts = {})
        feed_class = (opts[:class_name] || "#{listener}_feed".camelize).constantize
        feed_classes << feed_class
      end

      def feed_classes
        @feed_classes ||= []
      end

    end

    module InstanceMethods

      def distribute
        destination_feeds.each { |feed| feed.distribute(self) }
      end

      def destination_feeds
        self.class.feed_classes.map { |feed_class| feed_class.new(self) }
      end

    end
  end


end
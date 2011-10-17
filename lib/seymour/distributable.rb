module Seymour

  module Distributable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      DEFAULT_BATCH_SIZE = 500

      attr_accessor :audience_names, :feed_class_names

      def audience(*names)
        options = names.extract_options!
        names.each do |name|
          feed_name = options[:feed] || "#{name.downcase.to_s.singularize}_feed".camelize
          audience_to_feed_classes[name] = feed_name
        end
      end

      def audience_names
        audience_to_feed_classes.keys
      end

      def feed_class_names
        audience_to_feed_classes.values
      end

      def feeds_for(activity)
        [].tap do |feeds|
          audience_to_feed_classes.map do |audience_name, feed_class_name|
            try_find_each(activity.send(audience_name)) do |member|
              feeds << feed_class_name.constantize.new(member)
            end
          end
        end
      end

      private

      def audience_to_feed_classes
        @audience_to_feed_classes ||= {}
      end

      def try_find_each(activity_audience, &block)
        if defined? activity_audience.find_each
          activity_audience.find_each(:batch_size => DEFAULT_BATCH_SIZE) &block
        else
          activity_audience.each &block
        end
      end

    end

    module InstanceMethods

      def distribute
        feeds.map { |feed| feed.push(self) }
      end

      def feeds
        self.class.feeds_for(self)
      end

    end
  end


end
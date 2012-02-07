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
          feed_name = options.delete(:feed) || "#{name.to_s.downcase.singularize}_feed".camelize
          audience_mappings[name] = [feed_name, options]
        end
      end

      def audience_names
        audience_mappings.keys
      end

      def feed_class_names
        audience_mappings.values.map(&:first).flatten
      end

      def feeds_for(activity)
        tap_feeds_for(activity)
      end

      def distribute(activity)
        tap_feeds_for(activity) { |feed| feed.push(activity) }
      end

      def remove(activity)
        tap_feeds_for(activity) { |feed| feed.remove(activity) }
      end

      private

      def tap_feeds_for(activity, &block)
        [].tap do |feeds|
          audience_mappings.each do |audience_name, mapping|
            feed_classes, options = mapping
            [feed_classes].flatten.each do |feed_class_name|
              try_find_each(activity.send(audience_name), options) do |member|
                feed = feed_class_name.constantize.new(member)
                yield feed if block_given?
                feeds << feed
              end
            end
          end
        end
      end

      def audience_mappings
        @audience_mappings ||= {}
      end

      def try_find_each(activity_audience, options = {}, &block)
        if defined? activity_audience.find_each
          options[:batch_size] ||= DEFAULT_BATCH_SIZE

          # TODO support exclusive scope
          # activity_audience.find_each(options) do
          #   relation.send(:with_exclusive_scope) &block
          # end
          activity_audience.find_each(options, &block)
        else
          activity_audience.each &block
        end
      end

    end
    
    # instance methods

    def distribute
      self.class.distribute(self)
    end

    def remove
      self.class.remove(self)
    end

    def feeds
      self.class.feeds_for(self)
    end

  end


end

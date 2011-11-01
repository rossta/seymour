module Seymour
  class Feed

    attr_accessor :owner

    class << self
      def key(&block)
        define_method('key_to_store', &block)
      end

      def distribute(activity)
        activity.distribute
      end

      def inherited(subclass)
        feed_classes << subclass
      end

      def feed_classes
        @@feed_classes ||= []
      end
    end

    def initialize(owner)
      @owner = owner
    end

    delegate  :key, :key=, :push, :perform_push, :sort, :sort!, :insert_and_order, :bulk_push,
              :remove, :remove_id, :remove_all, :perform_push, :ids, :activity_ids, :to => :store

    protected

    def store
      @store ||= Seymour::Redis::List.new(key_to_store)
    end

    def key_to_store
      "#{owner_name}:#{id_for_key}/#{feed_name}"
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

  end
end

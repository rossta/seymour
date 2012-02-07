require 'rails/generators'
module Seymour
  class FeedGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def build_feed
      feed_root = 'app/models/feeds'
      empty_directory feed_root
      template 'feed.rb', "#{feed_root}/#{singular_name}_feed.rb"
    end

  end
end

module Seymour
  class Railtie < Rails::Railtie
    config.app_generators.integration_tool :rspec
    config.app_generators.test_framework   :rspec

    generators do
      require 'generators/seymour/feed/feed_generator'
    end

    rake_tasks do
      require 'seymour/tasks/seymour_tasks'
    end

    initializer "seymour.acts_as_activity" do
      ActiveSupport.on_load :active_record do
        include ActsAsActivity
      end
    end
  end
end
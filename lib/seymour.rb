require "seymour/version"
require "seymour/redis"
require "seymour/store"
require "seymour/feed"
require "seymour/acts_as_activity"
require "seymour/distributable"
require "seymour/renderable"
require "seymour/render_controller"
require 'seymour/railtie' if defined?(Rails)

module Seymour
  extend self
end

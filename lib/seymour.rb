require "seymour/version"
require "seymour/redis"
require "seymour/store"
require "seymour/feed"
require "seymour/has_audience"
require "seymour/distributable"
if defined?(Rails)
  require "seymour/acts_as_activity"
  require "seymour/renderable"
  require "seymour/render_controller"
  require 'seymour/railtie'
end

module Seymour
  extend self
end

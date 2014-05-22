module Seymour
  module HasAudience

    def self.included(base)
      base.send :include, Distributable
      base.send :include, Renderable if defined?(Rails)
    end
  end
end

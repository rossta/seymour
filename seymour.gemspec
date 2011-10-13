# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "seymour/version"

Gem::Specification.new do |s|
  s.name        = "seymour"
  s.version     = Seymour::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Activity feed me, Seymour}
  s.description = %q{For adding activity feeds to Rails application}

  s.rubyforge_project = "seymour"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis-namespace", "~> 1.1.0"

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end

# gem build seymour.gemspec
# gem push seymour-x.x.x.gem

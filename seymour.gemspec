# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seymour/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seymour"
  s.version     = Seymour::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Activity feed me, Seymour}
  s.description = %q{For adding activity feeds to Rails application}
  
  s.require_paths = ["lib"]
  # s.files       = `git ls-files`.split("\n")
  s.files         = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "rails", "~> 3.1.1"
  s.add_dependency "redis-namespace", "~> 1.1.0"
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end

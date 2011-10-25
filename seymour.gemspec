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
  s.summary     = %q{Feed me activities, Seymour, please!}
  s.description = %q{Activity feed distribution for Rails applications}

  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split("\n")
  # s.files         = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "rails", "~> 3.0"
  s.add_dependency "redis-namespace"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'steak'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'ammeter'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "sqlite3"
end

source "http://rubygems.org"

# Declare your gem's dependencies in seymour.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
group :test, :development do
  gem 'ruby-debug19', :require => 'ruby-debug', :platform => :ruby_19
  gem 'ruby-debug', :platform => :ruby_18
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent' # Makes guard better
  gem 'growl_notify' # Makes guard better
  gem 'launchy'
  gem 'yard'
end

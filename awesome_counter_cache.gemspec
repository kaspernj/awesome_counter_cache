$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "awesome_counter_cache/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "awesome_counter_cache"
  s.version     = AwesomeCounterCache::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://github.com/kaspernj/awesome_counter_cache"
  s.summary     = "Counter caching with a bit more for Rails"
  s.description = "Counter caching with a bit more for Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "factory_bot_rails", "5.1.1"
  s.add_development_dependency "forgery", "0.7.0"
  s.add_development_dependency "rails", ">= 5.0.0", "< 6.0.0"
  s.add_development_dependency "rspec-rails", "3.8.2"
  s.add_development_dependency "rubocop", "0.74.0"
  s.add_development_dependency "sqlite3", "1.4.1"
  s.add_development_dependency "tzinfo-data"
end

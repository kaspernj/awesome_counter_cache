$LOAD_PATH.push File.expand_path("../lib", __FILE__)

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

  s.add_development_dependency "rails", "~> 4.2.4"
  s.add_development_dependency "rspec-rails", "3.4.0"
  s.add_development_dependency "factory_girl_rails", "4.5.0"
  s.add_development_dependency "sqlite3", "1.3.11"
  s.add_development_dependency "best_practice_project", "0.0.5"
  s.add_development_dependency "rubocop", "0.35.1"
  s.add_development_dependency "forgery", "0.6.0"
  s.add_development_dependency "test_after_commit", "0.4.2"
end

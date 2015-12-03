$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "awesome_counter_cache/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "awesome_counter_cache"
  s.version     = AwesomeCounterCache::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AwesomeCounterCache."
  s.description = "TODO: Description of AwesomeCounterCache."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_development_dependency "rails", "~> 4.2.4"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "best_practice_project", "0.0.5"
  s.add_development_dependency "rubocop", "0.35.1"
end

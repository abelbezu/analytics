$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "analytics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "proctorserv_analytics"
  s.version     = Analytics::VERSION
  s.authors     = ["Max Lahey"]
  s.email       = ["max@proctorcam.com"]
  s.homepage    = "http://gitlab.proctorcam.com/analytics-gem"
  s.summary     = "ProctorCam Analytics"
  s.description = "Models and Sidekiq Workers for ProctorCam analytics"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "4.2.6"
  s.add_dependency "sidekiq"
  s.add_dependency "mysql2"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "ruby_gntp"
  s.add_development_dependency "growl"
end

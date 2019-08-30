Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "Reputation engine for Rails apps"
  s.description = "Manage badges, points and rankings (reputation) in your Rails app."
  s.homepage    = "https://github.com/merit-gem/merit"
  s.files       = `git ls-files`.split("\n").reject{|f| f =~ /^\./ }
  s.test_files  = `git ls-files -- test/*`.split("\n")
  s.license     = 'MIT'
  s.version     = '3.0.3'
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'ambry', '~> 1.0.0'
  s.add_development_dependency 'rails', '>= 5.1.6'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'mocha'
end

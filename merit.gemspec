Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "General reputation Rails engine."
  s.description = "Manage badges, points and rankings (reputation) of resources in a Rails application."
  s.homepage    = "http://github.com/tute/merit"
  s.files       = `git ls-files`.split("\n").reject{|f| f =~ /^\./ }
  s.license     = 'MIT'
  s.version     = '2.1.2'
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'ambry',  '~> 0.3.0'
  s.add_development_dependency 'rails', '>= 3.2.0'
  s.add_development_dependency 'jquery-rails', '~> 2.1'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'mocha', '0.14'
end

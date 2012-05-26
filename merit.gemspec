Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "General reputation Rails engine."
  s.description = "Manage badges, points and rankings (reputation) of resources in a Rails application."
  s.homepage    = "http://github.com/tute/merit"
  s.files       = `git ls-files`.split("\n").reject{|f| f =~ /^\./ }
  s.version     = "0.7.0"
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'
  s.add_dependency 'ambry'
  s.add_development_dependency 'rails', '~> 3.2.3'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'simplecov'
end

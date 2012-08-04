Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "General reputation Rails engine."
  s.description = "Manage badges, points and rankings (reputation) of resources in a Rails application."
  s.homepage    = "http://github.com/tute/merit"
  s.files       = `git ls-files`.split("\n").reject{|f| f =~ /^\./ }
  s.version     = "0.9.2"
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'

  if File.exists?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.add_dependency 'ambry',  '~> 0.3.0'
  s.add_development_dependency 'rails', '~> 3.2.3'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'simplecov'
  # Testing with Mongoid
  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'mongoid', '~> 2.0.0'
end

# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "General reputation Rails engine."
  s.description = "General reputation Rails engine."
  s.files       = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version     = "0.2.2"
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'
end

# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "merit"
  s.summary     = "General reputation Rails engine."
  s.description = "General reputation Rails engine."
  s.files       = `git ls-files`.split("\n").reject{|f| f =~ /^\./ }
  s.version     = "0.2.5"
  s.authors     = ["Tute Costa"]
  s.email       = 'tutecosta@gmail.com'
end

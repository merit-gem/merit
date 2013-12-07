source 'https://rubygems.org'

gemspec

version = ENV['RAILS_VERSION'] || '3.2'
rails = case version
when 'master'
  { github: 'rails/rails' }
when '4.0'
  "~> #{version}.0"
when '3.2'
  gem 'strong_parameters'
  "~> #{version}.0"
end

gem 'rails', rails

source 'https://rubygems.org'

gemspec

version = ENV['RAILS_VERSION'] || '4.2'
rails = case version
when 'master'
  { github: 'rails/rails' }
when '4.0-protected-attributes'
  gem 'protected_attributes'
  "~> 4.0.0"
when /4\.0|4\.1/
  "~> #{version}.0"
when /4\.2/
  "~> #{version}.0.rc2"
when '3.2'
  gem 'strong_parameters'
  "~> #{version}.0"
end

gem 'rails', rails

case ENV['ORM']
when 'active_record'
  gem 'activerecord'
when 'mongoid'
  gem 'mongoid'
end

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => [:jruby]
  gem 'sqlite3', '1.3.8', :platforms => [:ruby, :mswin, :mingw]
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'psych'
  gem 'racc'
  gem 'minitest'
  gem 'rubinius-developer_tools'
end

gem 'coveralls', require: false

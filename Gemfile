source 'https://rubygems.org'

gemspec

gem 'rails', "~> #{ENV.fetch('RAILS_VERSION', 6.0)}"

case ENV['ORM']
when 'active_record'
  gem 'activerecord'
when 'mongoid'
  gem 'mongoid'
end

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => [:jruby]
  gem 'sqlite3', '~> 1.4'
end

gem 'coveralls', require: false

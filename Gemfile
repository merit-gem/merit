source 'https://rubygems.org'

gemspec

version = ENV['RAILS_VERSION']
if version =~ /^5.2/
  gem 'rails', github: "rails/rails", branch: "5-2-stable"
elsif version =~/^6.0/
  gem 'rails', "~> 6.0.0.beta1"
else
  gem 'rails', version
end

case ENV['ORM']
when 'active_record'
  gem 'activerecord'
when 'mongoid'
  gem 'mongoid'
end

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => [:jruby]
  gem 'sqlite3', '~> 1.3.6'
end

gem 'coveralls', require: false

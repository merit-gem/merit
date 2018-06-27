source 'https://rubygems.org'

gemspec

gem 'rails', github: "rails/rails", branch: "5-2-stable"

case ENV['ORM']
when 'active_record'
  gem 'activerecord'
when 'mongoid'
  gem 'mongoid'
end

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => [:jruby]
  gem 'sqlite3', '~> 1.3.8', :platforms => [:ruby, :mswin, :mingw]
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'psych'
  gem 'racc'
  gem 'minitest', '~> 5.10', '!= 5.10.2'
  gem 'rubinius-developer_tools'
end

gem 'coveralls', require: false

# encoding: UTF-8
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake/testtask'

desc 'Default: run tests for all ORMs.'
task default: [:setup, :test, :api_test]

task :setup do
  system "cd test/dummy && rake db:migrate && rake db:test:prepare"
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

Rake::TestTask.new(:api_test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb'].exclude(/navigation_test.rb/)
  t.verbose = true
  t.options = '-- -api-only'
end

begin
  require 'rdoc/task'
  Rake::RDocTask.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title    = 'Merit'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README.md')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  puts 'This platform does not support RDocTask'
end

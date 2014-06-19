# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "json_store"
  gem.homepage = "http://github.com/kingsleyh/json_store"
  gem.license = "MIT"
  gem.summary = %Q{A simple in memory key/value database using json}
  gem.description = %Q{A simple in memory key/value database using json that writes to file}
  gem.email = "kingsleyhendrickse@me.com"
  gem.authors = ["Kingsley Hendrickse"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new



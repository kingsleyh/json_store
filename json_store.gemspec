# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: json_store 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "json_store"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kingsley Hendrickse"]
  s.date = "2014-06-23"
  s.description = "A simple in memory key/value database using json that writes to file"
  s.email = "kingsleyhendrickse@me.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "lib/json_store.rb",
  ]
  s.homepage = "http://github.com/kingsleyh/json_store"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "A simple in memory key/value database using json"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oj>, [">= 0"])
      s.add_runtime_dependency(%q<lock_method>, [">= 0"])
      s.add_runtime_dependency(%q<json_select>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0.0.rc1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
    else
      s.add_dependency(%q<oj>, [">= 0"])
      s.add_dependency(%q<lock_method>, [">= 0"])
      s.add_dependency(%q<json_select>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0.0.rc1"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    end
  else
    s.add_dependency(%q<oj>, [">= 0"])
    s.add_dependency(%q<lock_method>, [">= 0"])
    s.add_dependency(%q<json_select>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0.0.rc1"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
  end
end


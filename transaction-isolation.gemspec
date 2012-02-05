# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transaction_isolation/version"

Gem::Specification.new do |s|
  s.name        = "transaction_isolation"
  s.version     = TransactionIsolation::VERSION
  s.authors     = ["qertoip"]
  s.email       = ["qertoip@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Adds support for setting transaction isolation levels in ActiveRecord in a database agnostic way.}
  s.description = %q{Run transactions with a serializable / repeatable read / read committed / read uncommitted isolation level in MySQL, PostgreSQL and SQLite}
  
  s.rubyforge_project = "transaction_isolation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "activerecord"
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transaction_isolation/version"

Gem::Specification.new do |s|
  s.name        = "transaction_isolation"
  s.version     = TransactionIsolation::VERSION
  s.authors     = ["Piotr 'Qertoip' Włodarek"]
  s.email       = ["qertoip@gmail.com"]
  s.homepage    = "https://github.com/qertoip/transaction_isolation"
  s.summary     = %q{Set transaction isolation level in the ActiveRecord in a database agnostic way.}
  s.description = %q{Set transaction isolation level in the ActiveRecord in a database agnostic way.
Works with MySQL, PostgreSQL and SQLite as long as you are using new adapters mysql2, pg or sqlite3.
Supports all ANSI SQL isolation levels: :serializable, :repeatable_read, :read_committed, :read_uncommitted.}
  s.required_ruby_version = '>= 1.9.2'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activerecord", ">= 3.0.11"
end

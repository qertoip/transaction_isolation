source "http://rubygems.org"

# Specify your gem's dependencies in kontolib.gemspec
gemspec

group :test do
  # Use the gem instead of a dated version bundled with Ruby
  gem 'minitest', '2.8.1'

  # Allows to test for method invocations. Used sparingly but indispensable
  gem 'mocha', :require => false
  
  gem 'activerecord', "3.1.3"

  gem 'simplecov', :require => false
  
  # TDD (watch for file changes and fire the test)
  gem 'watchr'
  gem 'rev'

  gem 'mysql2'
  gem 'pg'
  gem 'sqlite3'
end

group :development do
  gem 'rake'
  # enhance irb
  gem 'awesome_print', :require => false
  gem 'pry', :require => false
end

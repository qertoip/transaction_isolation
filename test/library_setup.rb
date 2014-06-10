# Prepares application to be tested (requires files, connects to db, resets schema and data, applies patches, etc.)

# Initialize database
require 'db/all'

case ENV['db']
  when 'mysql2'
    TransactionIsolation::Test::Db.connect_to_mysql2
  when 'postgresql'
    TransactionIsolation::Test::Db.connect_to_postgresql
  when 'sqlite3'
    TransactionIsolation::Test::Db.connect_to_sqlite3
  else
    TransactionIsolation::Test::Db.connect_to_sqlite3
end

TransactionIsolation::Test::Migrations.run!

# Load the code that will be tested
require 'transaction_isolation'

require 'logger'
ActiveRecord::Base.logger = Logger.new( File.expand_path( "#{File.dirname( __FILE__ )}/log/test.log" ) )

TransactionIsolation.apply_activerecord_patch

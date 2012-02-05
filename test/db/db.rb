require 'fileutils'

module TransactionIsolation
  module Test
    module Db

      def self.connect_to_mysql2
        ::ActiveRecord::Base.establish_connection(
          :adapter => "mysql2",
          :database => "transaction_isolation_test", #database_filepath
          :user => 'root',
          :password => ''
        )
      end
      
      def self.connect_to_postgresql
        ::ActiveRecord::Base.establish_connection(
          :adapter => "postgresql",
          :database => "transaction_isolation_test", #database_filepath
          :user => 'qertoip',
          :password => 'test123'
        )
      end
      
      def self.connect_to_sqlite3
        ActiveRecord::Base.establish_connection(
          :adapter => "sqlite3",
          :database => ":memory:",
          :verbosity => "silent"
        )
      end

    end
  end
end

# All monkey patching is done in this file

ActiveRecord.send( :include, TransactionIsolation::ActiveRecord )
ActiveRecord::Base.extend( TransactionIsolation::ActiveRecord::Base )
ActiveRecord::ConnectionAdapters::AbstractAdapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::AbstractAdapter )
ActiveRecord::ConnectionAdapters::Mysql2Adapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::Mysql2Adapter )
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )
ActiveRecord::ConnectionAdapters::SQLite3Adapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::SQLite3Adapter )

if defined?( ActiveRecord::ConnectionAdapters::SQLiteAdapter )

  #require 'active_record/connection_adapters/sqlite3_adapter'

  module TransactionIsolation
    module ActiveRecord
      module ConnectionAdapters # :nodoc:
        module SQLite3Adapter

          def supports_isolation_levels?
            true
          end

          VENDOR_SPECIFIC_ISOLATION_LEVELS = {
            :read_uncommitted => 'read_uncommitted = true',
            :read_committed => 'read_uncommitted = false',
            :repeatable_read => 'read_uncommitted = false',
            :serializable => 'read_uncommitted = false'
          }

          TRANSACTION_CONFLICT_ERRORS = [
            "is locked"
          ]

          def isolation_level( level )
            validate_isolation_level( level )

            execute "PRAGMA #{VENDOR_SPECIFIC_ISOLATION_LEVELS[level]}"

            begin
              yield
            ensure
              execute "PRAGMA #{VENDOR_SPECIFIC_ISOLATION_LEVELS[initial_isolation_level]}"
            end if block_given?
          end

        end
      end
    end
  end

  ActiveRecord::ConnectionAdapters::SQLite3Adapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::SQLite3Adapter )

end
if defined?( ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )

  #require 'active_record/connection_adapters/postgresql_adapter'

  module TransactionIsolation
    module ActiveRecord
      module ConnectionAdapters # :nodoc:
        module PostgreSQLAdapter

          def supports_isolation_levels?
            true
          end

          VENDOR_SPECIFIC_ISOLATION_LEVELS = {
            :read_uncommitted => 'READ UNCOMMITTED',
            :read_committed => 'READ COMMITTED',
            :repeatable_read => 'REPEATABLE READ',
            :serializable => 'SERIALIZABLE'
          }

          TRANSACTION_CONFLICT_ERRORS = [
            "deadlock detected",
            "could not serialize access"
          ]

          def isolation_level( level )
            validate_isolation_level( level )

            execute "SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL #{VENDOR_SPECIFIC_ISOLATION_LEVELS[level]}"

            begin
              yield
            ensure
              execute "SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL #{'READ COMMITTED'}"
            end if block_given?
          end

        end
      end
    end
  end

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )

end
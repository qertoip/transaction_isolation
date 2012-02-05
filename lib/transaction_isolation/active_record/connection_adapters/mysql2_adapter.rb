if defined?( ActiveRecord::ConnectionAdapters::Mysql2Adapter )

  #require 'active_record/connection_adapters/mysql2_adapter'

  module TransactionIsolation
    module ActiveRecord
      module ConnectionAdapters # :nodoc:
        module Mysql2Adapter

          def included( base )
            base.class_eval do
              alias_method :translate_exception_without_transaction_isolation_conflict, :translate_exception
              alias_method :translate_exception, :translate_exception_with_transaction_isolation_conflict
            end
          end

          def supports_isolation_levels?
            true
          end

          VENDOR_SPECIFIC_ISOLATION_LEVELS = {
            :read_uncommitted => 'READ UNCOMMITTED',
            :read_committed => 'READ COMMITTED',
            :repeatable_read => 'REPEATABLE READ',
            :serializable => 'SERIALIZABLE'
          }

          def translate_exception_with_transaction_isolation_conflict( exception, message )
            if tx_isolation_conflict?( exception )
              ::ActiveRecord::TransactionIsolationConflict.new( "Transaction isolation conflict detected: #{exception.message}", exception )
            else
              translate_exception_without_transaction_isolation_conflict( exception, message )
            end
          end

          def tx_isolation_conflict?( exception )
            [ "Deadlock found when trying to get lock",
              "Lock wait timeout exceeded"].any? do |error_message|
              exception.message =~ /#{Regexp.escape( error_message )}/
            end
          end

          def isolation_level( level )
            validate_isolation_level( level )

            original_isolation = select_value( "select @@session.tx_isolation" ).gsub( '-', ' ' )

            execute( "SET SESSION TRANSACTION ISOLATION LEVEL #{VENDOR_SPECIFIC_ISOLATION_LEVELS[level]}" )

            begin
              yield
            ensure
              execute "SET SESSION TRANSACTION ISOLATION LEVEL #{original_isolation}"
            end if block_given?
          end

        end
      end
    end
  end

  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::Mysql2Adapter )

end
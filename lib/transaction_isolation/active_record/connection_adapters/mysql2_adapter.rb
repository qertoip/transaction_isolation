if defined?( ActiveRecord::ConnectionAdapters::Mysql2Adapter )

  module TransactionIsolation
    module ActiveRecord
      module ConnectionAdapters # :nodoc:
        module Mysql2Adapter

          def self.included( base )
            base.class_eval do
              alias_method :translate_exception_without_transaction_isolation_conflict, :translate_exception
              alias_method :translate_exception, :translate_exception_with_transaction_isolation_conflict
            end
          end
          
          def supports_isolation_levels?
            true
          end

          VENDOR_ISOLATION_LEVEL = {
              :read_uncommitted => 'READ UNCOMMITTED',
              :read_committed => 'READ COMMITTED',
              :repeatable_read => 'REPEATABLE READ',
              :serializable => 'SERIALIZABLE'
          }

          ANSI_ISOLATION_LEVEL = {
              'READ UNCOMMITTED' => :read_uncommitted,
              'READ COMMITTED' => :read_committed,
              'REPEATABLE READ' => :repeatable_read,
              'SERIALIZABLE' => :serializable
          }
          
          def current_isolation_level
            ANSI_ISOLATION_LEVEL[current_vendor_isolation_level]
          end
          
          def current_vendor_isolation_level
            select_value( "SELECT @@session.tx_isolation" ).gsub( '-', ' ' )
          end
          
          def isolation_level( level )
            validate_isolation_level( level )
            
            original_vendor_isolation_level = current_vendor_isolation_level if block_given?
            
            execute( "SET SESSION TRANSACTION ISOLATION LEVEL #{VENDOR_ISOLATION_LEVEL[level]}" )
            
            begin
              yield
            ensure
              execute "SET SESSION TRANSACTION ISOLATION LEVEL #{original_vendor_isolation_level}"
            end if block_given?
          end

          def translate_exception_with_transaction_isolation_conflict( exception, message )
            if isolation_conflict?( exception )
              ::ActiveRecord::TransactionIsolationConflict.new( "Transaction isolation conflict detected: #{exception.message}" )
            else
              translate_exception_without_transaction_isolation_conflict( exception, message )
            end
          end
          
          def isolation_conflict?( exception )
            [ "Deadlock found when trying to get lock",
              "Lock wait timeout exceeded"].any? do |error_message|
              exception.message =~ /#{Regexp.escape( error_message )}/i
            end
          end

        end
      end
    end
  end

  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send( :include, TransactionIsolation::ActiveRecord::ConnectionAdapters::Mysql2Adapter )

end
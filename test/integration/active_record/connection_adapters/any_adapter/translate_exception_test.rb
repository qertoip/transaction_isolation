# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < Minitest::Test

  class ConnectionAdaptersTest < Minitest::Test

    class AnyAdapterTest < Minitest::Test

      class TranslateExceptionTest < Minitest::Test

        def test_does_not_break_existing_translation
          assert_raises( ActiveRecord::StatementInvalid ) do
            ActiveRecord::Base.connection.execute( "WE LIVE IN THE MOST EXCITING TIMES EVER" )
          end
        end

        def test_translates_low_level_exceptions_to_transaction_isolation_level
          if defined?( ActiveRecord::ConnectionAdapters::Mysql2Adapter )
            message = "Deadlock found when trying to get lock"
            translated_exception = ActiveRecord::Base.connection.send( :translate_exception, Mysql2::Error.new( message ), message )
            assert_equal( ActiveRecord::TransactionIsolationConflict, translated_exception.class )
          end
          
          if defined?( ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )
            message = "deadlock detected"
            translated_exception = ActiveRecord::Base.connection.send( :translate_exception, PGError.new( message ), message )
            assert_equal( ActiveRecord::TransactionIsolationConflict, translated_exception.class )
          end
          
          if defined?( ActiveRecord::ConnectionAdapters::SQLite3Adapter )
            message = "The database file is locked"
            translated_exception = ActiveRecord::Base.connection.send( :translate_exception, StandardError.new( message ), message )
            assert_equal( ActiveRecord::TransactionIsolationConflict, translated_exception.class )
          end

        end

      end

    end

  end

end

# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < Minitest::Test

  class ConnectionAdaptersTest < Minitest::Test

    class AnyAdapterTest < Minitest::Test

      class CurrentIsolationLevelTest < Minitest::Test

        def test_returns_correct_default_isolation_level
          if defined?( ActiveRecord::ConnectionAdapters::Mysql2Adapter )
            assert_equal( :repeatable_read, ActiveRecord::Base.connection.current_isolation_level )
          end

          if defined?( ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )
            assert_equal( :read_committed, ActiveRecord::Base.connection.current_isolation_level )
          end

          if defined?( ActiveRecord::ConnectionAdapters::SQLite3Adapter )
            assert_equal( :serializable, ActiveRecord::Base.connection.current_isolation_level )
          end
        end

      end

    end

  end

end

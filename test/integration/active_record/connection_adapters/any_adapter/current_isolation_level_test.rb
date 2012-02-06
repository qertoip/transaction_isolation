# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < MiniTest::Unit::TestCase

  class ConnectionAdaptersTest < MiniTest::Unit::TestCase

    class AnyAdapterTest < MiniTest::Unit::TestCase

      class CurrentIsolationLevelTest < MiniTest::Unit::TestCase

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

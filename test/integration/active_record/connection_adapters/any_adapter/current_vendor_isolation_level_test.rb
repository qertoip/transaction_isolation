# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < MiniTest::Unit::TestCase

  class ConnectionAdaptersTest < MiniTest::Unit::TestCase

    class AnyAdapterTest < MiniTest::Unit::TestCase

      class CurrentVendorIsolationLevelTest < MiniTest::Unit::TestCase

        def test_returns_correct_default_vendor_isolation_level
          if defined?( ActiveRecord::ConnectionAdapters::Mysql2Adapter )
            assert_equal( 'REPEATABLE READ', ActiveRecord::Base.connection.current_vendor_isolation_level )
          end

          if defined?( ActiveRecord::ConnectionAdapters::PostgreSQLAdapter )
            assert_equal( 'READ COMMITTED', ActiveRecord::Base.connection.current_vendor_isolation_level )
          end

          if defined?( ActiveRecord::ConnectionAdapters::SQLite3Adapter )
            assert_equal( 'read_uncommitted = 0', ActiveRecord::Base.connection.current_vendor_isolation_level )
          end
        end

      end

    end

  end

end

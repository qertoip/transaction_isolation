# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < MiniTest::Unit::TestCase

  class ConnectionAdaptersTest < MiniTest::Unit::TestCase

    class AnyAdapterTest < MiniTest::Unit::TestCase

      class SupportsIsolationLevelsTest < MiniTest::Unit::TestCase

        def test_returns_true
          assert( ActiveRecord::Base.connection.supports_isolation_levels? )
        end

      end

    end

  end

end

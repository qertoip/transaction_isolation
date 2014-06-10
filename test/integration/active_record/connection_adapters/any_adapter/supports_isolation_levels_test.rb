# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < Minitest::Test

  class ConnectionAdaptersTest < Minitest::Test

    class AnyAdapterTest < Minitest::Test

      class SupportsIsolationLevelsTest < Minitest::Test

        def test_returns_true
          assert( ActiveRecord::Base.connection.supports_isolation_levels? )
        end

      end

    end

  end

end

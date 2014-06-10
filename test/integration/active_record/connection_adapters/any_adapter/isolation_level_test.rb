# -*- encoding : utf-8 -*-

require 'test_helper'

class ActiveRecordTest < Minitest::Test

  class ConnectionAdaptersTest < Minitest::Test

    class AnyAdapterTest < Minitest::Test

      class IsolationLevelTest < Minitest::Test

        def test_without_a_block
          original_isolation_level = ActiveRecord::Base.connection.current_isolation_level

          ActiveRecord::Base.connection.isolation_level( :read_uncommitted )
          assert_equal( :read_uncommitted, ActiveRecord::Base.connection.current_isolation_level )

          ActiveRecord::Base.connection.isolation_level( original_isolation_level )
          assert_equal( original_isolation_level, ActiveRecord::Base.connection.current_isolation_level )
        end

        def test_with_a_block
          original_isolation_level = ActiveRecord::Base.connection.current_isolation_level
          refute_equal( :read_uncommitted, original_isolation_level )

          ActiveRecord::Base.connection.isolation_level( :read_uncommitted ) do
            assert_equal( :read_uncommitted, ActiveRecord::Base.connection.current_isolation_level )
            ActiveRecord::Base.transaction do
              assert_equal( :read_uncommitted, ActiveRecord::Base.connection.current_isolation_level )
              QueuedJob.count
              QueuedJob.first
              assert_equal( :read_uncommitted, ActiveRecord::Base.connection.current_isolation_level )
            end
            assert_equal( :read_uncommitted, ActiveRecord::Base.connection.current_isolation_level )
          end

          assert_equal( original_isolation_level, ActiveRecord::Base.connection.current_isolation_level )
        end

        def test_with_all_possible_ansi_levels
          [:read_uncommitted, :read_committed, :repeatable_read, :serializable].each do |ansi_level|

            QueuedJob.isolation_level( ansi_level ) do

              # Some typical usage
              QueuedJob.transaction do
                QueuedJob.create!( :job => 'is fun' )
                assert_equal( 1, QueuedJob.count )
                raise ActiveRecord::Rollback
              end

            end
          end
        end

        def test_with_invalid_isolation_level
          assert_raises( ArgumentError ) do
            QueuedJob.isolation_level( :dupa )
          end
        end

      end

    end

  end

end

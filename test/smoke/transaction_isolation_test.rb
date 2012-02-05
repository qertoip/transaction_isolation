# -*- encoding : utf-8 -*-

require 'test_helper'

class TransactionIsolationTest < MiniTest::Unit::TestCase

  class QueuedJob < ActiveRecord::Base
  end

  def test_isolation_levels
    [:read_uncommitted, :read_committed, :repeatable_read, :serializable].each do
      QueuedJob.isolation_level( :serializable ) do
        QueuedJob.transaction do
          QueuedJob.create!( :job => 'sleep(1)' )
          assert_equal( 1, QueuedJob.count )
          raise ActiveRecord::Rollback
        end
      end
    end
  end
  
end

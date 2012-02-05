require 'active_record/base'

module TransactionIsolation
  module ActiveRecord
    module Base
      def isolation_level( isolation_level, &block )
        connection.isolation_level( isolation_level, &block )
      end
    end
  end
end

ActiveRecord::Base.extend( TransactionIsolation::ActiveRecord::Base )

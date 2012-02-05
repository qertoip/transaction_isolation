# Require version statement

require_relative 'transaction_isolation/version'

# Require modules with ActiveRecord enhancements

def apply_transaction_isolation_patch
  require 'active_record'
  require_relative 'transaction_isolation/active_record/errors'
  require_relative 'transaction_isolation/active_record/base'
  require_relative 'transaction_isolation/active_record/connection_adapters/abstract_adapter'
  require_relative 'transaction_isolation/active_record/connection_adapters/mysql2_adapter'
  require_relative 'transaction_isolation/active_record/connection_adapters/postgresql_adapter'
  require_relative 'transaction_isolation/active_record/connection_adapters/sqlite3_adapter'
end

$stderr.puts( "transaction_isolation" )

if defined?( Rails )
  Rails.application.config.after_initialize do
    $stderr.puts( "apply_transaction_isolation_patch" )
    apply_transaction_isolation_patch
  end
else
  apply_transaction_isolation_patch
end

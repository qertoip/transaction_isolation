require "active_record"
require_relative 'transaction_isolation/version'

module TransactionIsolation

  # Must be called after ActiveRecord established a connection.
  # Only then we know which connection adapter is actually loaded and can be enhanced.
  # Please note ActiveRecord does not load unused adapters.
  def self.apply_activerecord_patch
    require_relative 'transaction_isolation/active_record/errors'
    require_relative 'transaction_isolation/active_record/base'
    require_relative 'transaction_isolation/active_record/connection_adapters/abstract_adapter'
    require_relative 'transaction_isolation/active_record/connection_adapters/mysql2_adapter'
    require_relative 'transaction_isolation/active_record/connection_adapters/postgresql_adapter'
    require_relative 'transaction_isolation/active_record/connection_adapters/sqlite3_adapter'
  end

  if defined?( ::Rails )
    # Setup applying the patch after Rails is initialized.
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        TransactionIsolation.apply_activerecord_patch
      end
    end
  end
  
end

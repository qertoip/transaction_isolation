# transaction_isolation

Adds support for setting transaction isolation level in ActiveRecord in a database agnostic way.

## Example

    ActiveRecord::Base.isolation_level( :serializable ) do
      # your code
    end

## Installation

Add this to your Gemfile:

    gem 'transaction_isolation'

Then run:

    bundle

## Features

 * Setting transaction isolation level (:read_uncommitted, :read_committed, :repeatable_read, :serializable)
 * Auto-reverting to the original isolation level after the block
 * Database agnostic
 * MySQL2, PostgreSQL and SQLite3 database connection adapters supported
 * Exception translation. All deadlocks and serialization errors are wrapped in a ActiveRecord::TransactionIsolationConflict exception
 * Use it in your Rails application or a standalone ActiveRecord-based project

## Real world example

When implementing a table-based job queue you should ensure that only one worker process can pop a particular job from the queue.
Wrapping your code in a transaction is not enough because by default databases do not isolate transactions to the full extent,
which leads to occasional phantom reads. It is therefore necessary to manually raise the transaction isolation level.
The highest level of transaction isolation is called "serializable".

[Read about isolation levels in Wikipedia](http://tinyurl.com/nrqjbb)

    class QueuedJob < ActiveRecord::Base

      # Job status
      TODO = 1
      PROCESSING = 2
      DONE = 3

      # Returns first job from the queue or nil if the queue is empty
      def pop
        QueuedJob.isolation_level( :serializable ) do
          QueuedJob.transaction do
            queued_job = find_by_status( TODO )
            if queud_job
              queued_job.update_attribute( :status, PROCESSING )
              return queued_job
            else
              return nil
            end
          end
        end
      end

    end

## Requirements

 * Ruby 1.9
 * ActiveRecord 3.1+

## Running tests

Run tests on the selected database (mysql2 by default):

    db=mysql2 bundle exec rake test
    db=postgresql bundle exec rake test
    db=sqlite3 bundle exec rake test

Run tests on all supported databases:

    ./tests

Database configuration is hardcoded in test/db/db.rb; feel free to improve this and submit a pull request.

## How intrusive is this gem?

You should be very suspicious about any gem that monkey patches your stock Ruby on Rails framework.

This gem is carefully written to not be more intrusive than it needs to be:

 * introduces several new methods to Mysql2Adapter, PostgreSQLAdapter, SQLite3Adapter; names are carefully taken to not collide with future changes
 * wraps #translate_exception method using alias_method_chain to add new translation
 * introduces new class ActiveRecord::TransactionIsolationConflict in the ActiveRecord module
 * introduces new convenience method ActiveRecord::Base.isolation_level akin to ActiveRecord::Base.transaction

## License

Released under the MIT license. Copyright (C) 2012 Piotr 'Qertoip' Włodarek.
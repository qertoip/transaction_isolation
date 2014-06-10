# transaction_isolation

Set transaction isolation level in the ActiveRecord in a database agnostic way.
Works with MySQL, PostgreSQL and SQLite as long as you are using new adapters mysql2, pg or sqlite3.
Supports all ANSI SQL isolation levels: :serializable, :repeatable_read, :read_committed, :read_uncommitted.

See also [transaction_retry](https://github.com/qertoip/transaction_retry) gem for auto-retrying transactions 
on deadlocks and serialization errors.

## Example

    ActiveRecord::Base.isolation_level( :serializable ) do
      # your code
    end

## Installation

Add this to your Gemfile:

    gem 'transaction_isolation'

Then run:

    bundle

__It works out of the box with Ruby on Rails__.

If you have a standalone ActiveRecord-based project you'll need to call:

    TransactionIsolation.apply_activerecord_patch     # after connecting to the database

__after__ connecting to the database. This is because ActiveRecord loads adapters lazilly and only then they can be patched.

## Features

 * Setting transaction isolation level: :serializable, :repeatable_read, :read_committed, :read_uncommitted
 * Auto-reverting to the original isolation level after the block
 * Database agnostic
 * MySQL, PostgreSQL and SQLite supported
 * Exception translation. All deadlocks and serialization errors are wrapped in a ActiveRecord::TransactionIsolationConflict exception
 * Use it in your Rails application or a standalone ActiveRecord-based project

## Testimonials

This gem was initially developed for and successfully works in production at [Kontomierz.pl](http://kontomierz.pl) - the finest Polish personal finance app.

## Real world example

When implementing a table-based job queue you should ensure that only one worker process can pop a particular job from the queue.
Wrapping your code in a transaction is not enough because by default databases do not isolate transactions to the full extent,
which leads to occasional phantom reads. It is therefore necessary to manually raise the transaction isolation level.
The highest level of transaction isolation is called "serializable" and that's what we need here:

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
      rescue ActiveRecord::TransactionIsolationConflict => e
        logger.warn( e.message )
        retry
      end

    end

[Read more about isolation levels in Wikipedia](http://tinyurl.com/nrqjbb)

## Requirements

 * Ruby 1.9.2
 * ActiveRecord 3.0.11+

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
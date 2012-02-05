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
 * Use it in your Rails application or a standalone ActiveRecord-based project

## Real world example

When implementing a table-based job queue you should ensure that only one worker process can pop a particular job from the queue.
Wrapping your code in a transaction is not enough because by default databases do not isolate transactions to the full extent,
which leads to occasional phantom reads. It is therefore necessary to manually raise the transaction isolation level.
The highest level of transaction isolation is called "serializable".

[Read about isolation levels in Wikipedia](http://en.wikipedia.org/wiki/Isolation_(database_systems))

    ActiveRecord::Base.isolation_level( :serializable ) do
      ActiveRecord::Base.transaction do
        queued_job = find_by_status( TODO )
        if queud_job
          queued_job.update_attribute( :status, PROCESSING )
          return queued_job
        else
          return nil
        end
      end
    end


## Usage

    $( '.editable' ).editable( {
      type: 'datepicker'
    } );

## Requirements

 * Ruby 1.9
 * ActiveRecord 3.1+

## License

Released under the MIT license. Copyright (C) 2012 Piotr 'Qertoip' Włodarek.
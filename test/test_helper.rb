# Load test coverage tool (must be loaded before any code)
#require 'simplecov'
#SimpleCov.start do
#  add_filter '/test/'
#  add_filter '/config/'
#end

# Load and initialize the application to be tested
require 'library_setup'

# Load test frameworks
require 'minitest/autorun'
require 'mocha'

#if MiniTest::Unit.respond_to?(:use_natural_language_case_names=)
#  MiniTest::Unit.use_natural_language_case_names = true
#end

# Load minitest enhancements
require 'minitest/run_each_test_in_a_rolled_back_transaction'

# Custom reporters
#require 'minitest/reporters'
#MiniTest::Unit.runner = MiniTest::SuiteRunner.new
#MiniTest::Unit.runner.reporters << MiniTest::Reporters::ProgressReporter.new

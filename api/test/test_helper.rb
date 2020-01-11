require 'simplecov'
SimpleCov.start
require 'minitest/reporters'
Minitest::Reporters.use!

require 'codacy-coverage'
Codacy::Reporter.start

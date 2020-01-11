require 'simplecov'
SimpleCov.start
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world', greeting
  end
end

def greeting
  'hello world'
end

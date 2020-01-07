require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_greeting
    assert_equal 'Hello', FizzBuzz.greeting
  end
end

class FizzBuzz
  def self.greeting
    'Hello'
  end
end

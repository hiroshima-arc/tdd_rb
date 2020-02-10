# frozen_string_literal: true

require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class Fibonacci < Minitest::Test
  def fib(n)
    0
  end

  def test_fibonacci
    assert_equal 0, fib(0)
  end
end

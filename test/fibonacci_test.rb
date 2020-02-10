# frozen_string_literal: true

require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class Fibonacci < Minitest::Test
  def fib(n)
    return 0 if n.zero?

    1
  end

  def test_fibonacci
    assert_equal 0, fib(0)
    assert_equal 1, fib(1)
  end
end

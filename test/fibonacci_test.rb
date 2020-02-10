# frozen_string_literal: true

require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fibonacci'

class FibonacciTest < Minitest::Test
  def setup
    @fib = Fibonacci
  end

  def fib(number, memo = {})
    Fibonacci.calc(number, memo)
  end

  def test_fibonacci
    cases = [[0, 0], [1, 1], [2, 1], [3, 2], [4, 3], [5, 5]]
    cases.each do |i|
      assert_equal i[1], fib(i[0])
    end
  end

  def test_return_102334155_when_40
    assert_equal 102_334_155, fib(40)
  end
end

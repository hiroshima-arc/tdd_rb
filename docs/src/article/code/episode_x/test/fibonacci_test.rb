# frozen_string_literal: true

require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fibonacci'

class FibonacciTest < Minitest::Test
  def setup
    @fib = Fibonacci::Command.new(Fibonacci::Recursive.new)
    @recursive = Fibonacci::Command.new(Fibonacci::Recursive.new)
    @loop = Fibonacci::Command.new(Fibonacci::Loop.new)
    @general_term = Fibonacci::Command.new(Fibonacci::GeneralTerm.new)
  end

  def test_fibonacci
    cases = [[0, 0], [1, 1], [2, 1], [3, 2], [4, 3], [5, 5]]
    cases.each do |i|
      assert_equal i[1], @fib.calc(i[0])
    end
  end

  def test_large_number_recursive
    assert_equal 102_334_155, @recursive.calc(40)
  end

  def test_large_number_loop
    assert_equal 102_334_155, @loop.calc(40)
  end

  def test_large_number_general_term
    assert_equal 102_334_155, @general_term.calc(40)
  end
end

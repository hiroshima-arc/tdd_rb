# frozen_string_literal: true

require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class Fibonacci < Minitest::Test
  def greeting
    'hello world'
  end

  def test_greeting
    assert_equal 'hello world', greeting
  end
end

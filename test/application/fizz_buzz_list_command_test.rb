# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fizz_buzz'

class FizzBuzzListCommandTest < Minitest::Test
  describe '1から100までのFizzBuzzの配列を返す' do
    def setup
      fizz_buzz = FizzBuzzListCommand.new(FizzBuzzType01.new)
      fizz_buzz_list = fizz_buzz.execute(100)
      @result = fizz_buzz_list.value
    end

    def test_配列の初めは文字列の1を返す
      assert_equal '1', @result.first.value
    end

    def test_配列の最後は文字列のBuzzを返す
      assert_equal 'Buzz', @result.last.value
    end

    def test_配列の2番目は文字列のFizzを返す
      assert_equal 'Fizz', @result[2].value
    end

    def test_配列の4番目は文字列のBuzzを返す
      assert_equal 'Buzz', @result[4].value
    end

    def test_配列の14番目は文字列のFizzBuzzを返す
      assert_equal 'FizzBuzz', @result[14].value
    end
  end
end

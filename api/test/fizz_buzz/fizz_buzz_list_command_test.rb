require 'minitest/autorun'
require_relative '../../fizz_buzz/application/fizz_buzz_list_command.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type_01.rb'

class FizzBuzzListCommandTest < Minitest::Test
  describe '1から100までの数を返す' do
    def setup
      fizzbuzz =
        FizzBuzz::Application::FizzBuzzListCommand.new(
          FizzBuzz::Domain::Type::FizzBuzzType.create(
            FizzBuzz::Domain::Type::FizzBuzzType::TYPE_01
          )
        )
      fizzbuzz_list = fizzbuzz.execute(100)
      @result = fizzbuzz_list.value
    end

    def test_はじめは文字列1を返す
      assert_equal '1', @result.first.value
    end

    def test_最後は文字列Buzzを返す
      assert_equal 'Buzz', @result.last.value
    end

    def test_2番目は文字列Fizzを返す
      assert_equal 'Fizz', @result[2].value
    end

    def test_4番目は文字列Buzzを返す
      assert_equal 'Buzz', @result[4].value
    end

    def test_14番目は文字列FizzBuzzを返す
      assert_equal 'FizzBuzz', @result[14].value
    end

    def test_100より多い数を許可しない
      e =
        assert_raises RuntimeError do
          FizzBuzz::Application::FizzBuzzListCommand.new(
            FizzBuzz::Domain::Type::FizzBuzzType.create(
              FizzBuzz::Domain::Type::FizzBuzzType::TYPE_01
            )
          )
            .execute(101)

          assert_equal '上限は100件までです', e.message
        end
    end
  end
end

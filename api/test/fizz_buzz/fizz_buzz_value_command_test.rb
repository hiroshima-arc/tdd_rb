require 'minitest/autorun'
require_relative '../../fizz_buzz/application/fizz_buzz_value_command.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type_01.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type_02.rb'
require_relative '../../fizz_buzz/domain/type/fizz_buzz_type_03.rb'

class FizzBuzzValueCommandTest < Minitest::Test
  describe 'タイプ1の場合' do
    describe '数を文字列にして返す' do
      def setup
        @fizzbuzz =
          FizzBuzz::Application::FizzBuzzValueCommand.new(
            FizzBuzz::Domain::Type::FizzBuzzType.create(
              FizzBuzz::Domain::Type::FizzBuzzType::TYPE_01
            )
          )
      end

      describe '三の倍数の場合' do
        def test_3を渡したら文字列Fizzを返す
          assert_equal 'Fizz', @fizzbuzz.execute(3).value
        end
      end

      describe '五の倍数の場合' do
        def test_5を渡したら文字列Buzzを返す
          assert_equal 'Buzz', @fizzbuzz.execute(5).value
        end
      end

      describe '三と五の倍数の場合' do
        def test_15を渡したら文字列FizzBuzzを返す
          assert_equal 'FizzBuzz', @fizzbuzz.execute(15).value
        end
      end

      describe 'その他の場合' do
        def test_1を渡したら文字列1を返す
          assert_equal '1', @fizzbuzz.execute(1).value
        end

        def test_値は正の値のみ許可する
          e =
            assert_raises RuntimeError do
              FizzBuzz::Application::FizzBuzzValueCommand.new(
                FizzBuzz::Domain::Type::FizzBuzzType.create(
                  FizzBuzz::Domain::Type::FizzBuzzType::TYPE_01
                )
              )
                .execute(-1)
            end

          assert_equal '正の値のみ有効です', e.message
        end
      end
    end
  end

  describe 'タイプ2の場合' do
    describe '数を文字列にして返す' do
      def setup
        @fizzbuzz =
          FizzBuzz::Application::FizzBuzzValueCommand.new(
            FizzBuzz::Domain::Type::FizzBuzzType.create(
              FizzBuzz::Domain::Type::FizzBuzzType::TYPE_02
            )
          )
      end

      describe '三の倍数の場合' do
        def test_3を渡したら文字列3を返す
          assert_equal '3', @fizzbuzz.execute(3).value
        end
      end

      describe '五の倍数の場合' do
        def test_5を渡したら文字列5を返す
          assert_equal '5', @fizzbuzz.execute(5).value
        end
      end

      describe '三と五の倍数の場合' do
        def test_15を渡したら文字列15を返す
          assert_equal '15', @fizzbuzz.execute(15).value
        end
      end

      describe 'その他の場合' do
        def test_1を渡したら文字列1を返す
          assert_equal '1', @fizzbuzz.execute(1).value
        end
      end
    end
  end

  describe 'タイプ3の場合' do
    describe '数を文字列にして返す' do
      def setup
        @fizzbuzz =
          FizzBuzz::Application::FizzBuzzValueCommand.new(
            FizzBuzz::Domain::Type::FizzBuzzType.create(
              FizzBuzz::Domain::Type::FizzBuzzType::TYPE_03
            )
          )
      end

      describe '三の倍数の場合' do
        def test_3を渡したら文字列3を返す
          assert_equal '3', @fizzbuzz.execute(3).value
        end
      end

      describe '五の倍数の場合' do
        def test_5を渡したら文字列5を返す
          assert_equal '5', @fizzbuzz.execute(5).value
        end
      end

      describe '三と五の倍数の場合' do
        def test_15を渡したら文字列FizzBuzzを返す
          assert_equal 'FizzBuzz', @fizzbuzz.execute(15).value
        end
      end

      describe 'その他の場合' do
        def test_1を渡したら文字列1を返す
          assert_equal '1', @fizzbuzz.execute(1).value
        end
      end
    end
  end

  describe 'それ以外のタイプの場合' do
    def test_例外を返す
      e =
        assert_raises RuntimeError do
          FizzBuzz::Domain::Type::FizzBuzzType.create(4)
        end

      assert_equal '該当するタイプは存在しません', e.message
    end
  end
end

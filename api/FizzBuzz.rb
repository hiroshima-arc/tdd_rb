require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    describe 'タイプ1の場合' do
      describe '数を文字列にして返す' do
        def setup
          @fizzbuzz = FizzBuzz.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
        end

        describe '三の倍数の場合' do
          def test_3を渡したら文字列Fizzを返す
            assert_equal 'Fizz', @fizzbuzz.generate(3).value
          end
        end

        describe '五の倍数の場合' do
          def test_5を渡したら文字列Buzzを返す
            assert_equal 'Buzz', @fizzbuzz.generate(5).value
          end
        end

        describe '三と五の倍数の場合' do
          def test_15を渡したら文字列FizzBuzzを返す
            assert_equal 'FizzBuzz', @fizzbuzz.generate(15).value
          end
        end

        describe 'その他の場合' do
          def test_1を渡したら文字列1を返す
            assert_equal '1', @fizzbuzz.generate(1).value
          end
        end

        describe '1から100までの数を返す' do
          def setup
            fizzbuzz = FizzBuzz.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
            @result = fizzbuzz.generate_list
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
        end
      end
    end

    describe 'タイプ2の場合' do
      describe '数を文字列にして返す' do
        def setup
          @fizzbuzz = FizzBuzz.new(FizzBuzzType.create(FizzBuzzType::TYPE_02))
        end

        describe '三の倍数の場合' do
          def test_3を渡したら文字列3を返す
            assert_equal '3', @fizzbuzz.generate(3).value
          end
        end

        describe '五の倍数の場合' do
          def test_5を渡したら文字列5を返す
            assert_equal '5', @fizzbuzz.generate(5).value
          end
        end

        describe '三と五の倍数の場合' do
          def test_15を渡したら文字列15を返す
            assert_equal '15', @fizzbuzz.generate(15).value
          end
        end

        describe 'その他の場合' do
          def test_1を渡したら文字列1を返す
            assert_equal '1', @fizzbuzz.generate(1).value
          end
        end
      end
    end

    describe 'タイプ3の場合' do
      describe '数を文字列にして返す' do
        def setup
          @fizzbuzz = FizzBuzz.new(FizzBuzzType.create(FizzBuzzType::TYPE_03))
        end

        describe '三の倍数の場合' do
          def test_3を渡したら文字列3を返す
            assert_equal '3', @fizzbuzz.generate(3).value
          end
        end

        describe '五の倍数の場合' do
          def test_5を渡したら文字列5を返す
            assert_equal '5', @fizzbuzz.generate(5).value
          end
        end

        describe '三と五の倍数の場合' do
          def test_15を渡したら文字列FizzBuzzを返す
            assert_equal 'FizzBuzz', @fizzbuzz.generate(15).value
          end
        end

        describe 'その他の場合' do
          def test_1を渡したら文字列1を返す
            assert_equal '1', @fizzbuzz.generate(1).value
          end
        end
      end
    end

    describe 'それ以外のタイプの場合' do
      def test_例外を返す
        e =
          assert_raises RuntimeError do
            FizzBuzzType.create(4)
          end

        assert_equal '該当するタイプは存在しません', e.message
      end
    end
  end
end

class FizzBuzz
  MAX_NUMBER = 100
  attr_reader :list

  def initialize(type)
    @type = type
  end

  def generate(number)
    @type.generate(number)
  end

  def generate_list
    @list = (1..MAX_NUMBER).map { |i| @type.generate(i) }
  end
end

class FizzBuzzType
  TYPE_01 = 1
  TYPE_02 = 2
  TYPE_03 = 3

  def self.create(type)
    case type
    when 1
      FizzBuzzType01.new
    when 2
      FizzBuzzType02.new
    when 3
      FizzBuzzType03.new
    else
      raise '該当するタイプは存在しません'
    end
  end

  def is_fizz(number)
    number.modulo(3).zero?
  end

  def is_buzz(number)
    number.modulo(5).zero?
  end
end

class FizzBuzzType01 < FizzBuzzType
  def generate(number)
    if is_fizz(number) && is_buzz(number)
      return FizzBuzzValue.new(number, 'FizzBuzz')
    end
    return FizzBuzzValue.new(number, 'Fizz') if is_fizz(number)
    return FizzBuzzValue.new(number, 'Buzz') if is_buzz(number)
    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType02 < FizzBuzzType
  def generate(number)
    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType03 < FizzBuzzType
  def generate(number)
    if is_fizz(number) && is_buzz(number)
      return FizzBuzzValue.new(number, 'FizzBuzz')
    end
    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzValue
  attr_reader :number, :value

  def initialize(number, value)
    @number = number
    @value = value
  end

  def to_s
    "#{@number}:#{@value}"
  end

  def ==(other)
    @number == other.number && @value == other.value
  end

  alias eql? ==
end

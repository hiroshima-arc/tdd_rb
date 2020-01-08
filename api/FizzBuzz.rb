require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    describe 'タイプ1の場合' do
      describe '数を文字列にして返す' do
        def setup
          @fizzbuzz =
            FizzBuzzValueCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
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
            assert_raises Assertions::AssertionError do
              FizzBuzzValueCommand.new(
                FizzBuzzType.create(FizzBuzzType::TYPE_01)
              )
                .execute(-1)
            end
          end

          def test_100より多い数を許可しない
            assert_raises Assertions::AssertionError do
              FizzBuzzListCommand.new(
                FizzBuzzType.create(FizzBuzzType::TYPE_01)
              )
                .execute(101)
            end
          end
        end

        describe '1から100までの数を返す' do
          def setup
            fizzbuzz =
              FizzBuzzListCommand.new(
                FizzBuzzType.create(FizzBuzzType::TYPE_01)
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
        end
      end
    end

    describe 'タイプ2の場合' do
      describe '数を文字列にして返す' do
        def setup
          @fizzbuzz =
            FizzBuzzValueCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_02))
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
            FizzBuzzValueCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_03))
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
            FizzBuzzType.create(4)
          end

        assert_equal '該当するタイプは存在しません', e.message
      end
    end
  end

  describe 'FizzBuzzValue' do
    def setup
      @fizzbuzz =
        FizzBuzzValueCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
    end

    def test_同じ値
      value1 = @fizzbuzz.execute(1)
      value2 = @fizzbuzz.execute(1)

      assert value1.eql?(value2)
    end

    def test_to_string
      value = @fizzbuzz.execute(3)

      assert_equal '3:Fizz', value.to_s
    end
  end

  describe 'FizzBuzzList' do
    def setup
      @fizzbuzz =
        FizzBuzzListCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
    end

    def test_新しいインスタンスが作られる
      list1 = @fizzbuzz.execute(50)
      list2 = list1.add(list1.value)

      assert_equal 50, list1.value.count
      assert_equal 100, list2.value.count
    end

    def test_to_string
      list = @fizzbuzz.execute(100)

      assert_equal '1', list.to_s[0]
      assert_equal 'Buzz', list.to_s[99]
    end
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

module Assertions
  class AssertionError < StandardError; end

  def assert(&condition)
    raise AssertionError.new('Assertion Failed') unless condition.call
  end
end

class FizzBuzzValue
  include Assertions
  attr_reader :number, :value

  def initialize(number, value)
    assert { number >= 0 }

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

class FizzBuzzList
  include Assertions
  attr_reader :value

  def initialize(list)
    assert { list.count <= 100 }

    @value = list
  end

  def to_s
    @value.map { |i| i.value.to_s }
  end

  def add(value)
    FizzBuzzList.new(@value + value)
  end
end

class FizzBuzzCommand; end

class FizzBuzzValueCommand < FizzBuzzCommand
  def initialize(type)
    @type = type
  end

  def execute(number)
    @type.generate(number)
  end
end

class FizzBuzzListCommand < FizzBuzzCommand
  def initialize(type)
    @type = type
  end

  def execute(number)
    FizzBuzzList.new((1..number).map { |i| @type.generate(i) })
  end
end

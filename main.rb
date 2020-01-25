require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    def setup
      @fizzbuzz = FizzBuzz
    end

    describe '三の倍数の場合' do
      def test_3を渡したら文字列Fizzを返す
        assert_equal 'Fizz', @fizzbuzz.generate(3)
      end
    end

    describe '五の倍数の場合' do
      def test_5を渡したら文字列Buzzを返す
        assert_equal 'Buzz', @fizzbuzz.generate(5)
      end
    end

    describe '三と五の倍数の場合' do
      def test_15を渡したら文字列FizzBuzzを返す
        assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
      end
    end

    describe 'その他の場合' do
      def test_1を渡したら文字列1を返す
        assert_equal '1', @fizzbuzz.generate(1)
      end

      def test_2を渡したら文字列2を返す
        assert_equal '2', @fizzbuzz.generate(2)
      end
    end

    describe '1から100までのFizzBuzzの配列を返す' do
      def setup
        @result = FizzBuzz.print_1_to_100
      end

      def test_配列の初めは文字列の1を返す
        assert_equal '1', @result.first
      end

      def test_配列の最後は文字列のBuzzを返す
        assert_equal 'Buzz', @result.last
      end

      def test_配列の2番目は文字列のFizzを返す
        assert_equal 'Fizz', @result[2]
      end

      def test_配列の4番目は文字列のBuzzを返す
        assert_equal 'Buzz', @result[4]
      end

      def test_配列の14番目は文字列のFizzBuzzを返す
        assert_equal 'FizzBuzz', @result[14]
      end
    end
  end
end

class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end

  def self.print_1_to_100
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end

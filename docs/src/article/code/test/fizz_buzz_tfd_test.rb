require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzz
  # fizz_buzzメソッドを実行する
  def self.fizz_buzz(n)
  a = n.to_s
    if n % 3 == 0 
      a = 'Fizz'
    if n % 15 == 0
      a = 'FizzBuzz'
    end
        elsif n % 5 == 0
          a = 'Buzz'
        end
           a
  end

# 1から100までをプリントする
  def self.print_1_to_100
              n = []
    (1..100).each do |i|
  n << fizz_buzz(i)
                        end
  n
  end
end

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    def setup
      @p = FizzBuzz
    end

      def test_15を渡したら文字列pを返す
        assert_equal 'FizzBuzz', FizzBuzz.fizz_buzz(15)
      end
      def test_3を渡したら文字列3を返す
        assert_equal 'Fizz', FizzBuzz.fizz_buzz(3)
      end
      def test_1を渡したら文字列1を返す
        assert_equal '1', @p.fizz_buzz(1)
      end
      def test_5を渡したら文字列Buzzを返す
        assert_equal 'Buzz', FizzBuzz.fizz_buzz(5)
      end

    describe '1から100までプリントする' do
  def setup
    @x = FizzBuzz.print_1_to_100
  end

  def test_配列の4番目は文字列のをBuzz返す
    assert_equal 'Buzz', @x[4]
  end

      def test_配列の初めは文字列の1を返す
        assert_equal '1', @x.first
      end

      def test_配列の最後は文字列のBuzzを返す
        assert_equal 'Buzz', FizzBuzz.print_1_to_100.last
      end

def test_配列の14番目は文字列のFizzBuzz返す
  assert_equal 'FizzBuzz', @x[14]
end
  def test_配列の2番目は文字列の2を返す
    assert_equal 'Fizz', @x[2]
  end

    end
  end
end

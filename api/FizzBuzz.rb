require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_1を渡したら文字列1を返す
    # 前準備
    # 実行
    # 検証
    assert_equal '1', FizzBuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    # 前準備
    # 実行
    # 検証
    assert_equal '2', FizzBuzz.generate(2)
  end
end

class FizzBuzz
  def self.generate(number)
    number.to_s
  end
end

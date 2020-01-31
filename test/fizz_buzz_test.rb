# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fizz_buzz'

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    describe '数を文字列にして返す' do
      describe 'タイプ1の場合' do
        def setup
          @fizzbuzz = FizzBuzzValueCommand.new(FizzBuzzType01.new)
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
        end

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

      describe 'タイプ2の場合' do
        def setup
          @fizzbuzz = FizzBuzzValueCommand.new(FizzBuzzType02.new)
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

      describe 'タイプ3の場合' do
        def setup
          @fizzbuzz = FizzBuzzValueCommand.new(FizzBuzzType03.new)
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

      describe 'それ以外のタイプの場合' do
        def test_例外を返す
          e = assert_raises RuntimeError do
            @fizzbuzz = FizzBuzzType.create(4)
          end

          assert_equal '該当するタイプは存在しません', e.message
        end
      end

      describe '例外ケース' do
        def test_値は正の値のみ許可する
          assert_raises Assertions::AssertionFailedError do
            FizzBuzzValueCommand.new(
              FizzBuzzType.create(FizzBuzzType::TYPE_01)
            ).execute(-1)
          end
        end

        def test_100より多い数を許可しない
          assert_raises Assertions::AssertionFailedError do
            FizzBuzzListCommand.new(
              FizzBuzzType.create(FizzBuzzType::TYPE_01)
            ).execute(101)
          end
        end
      end
    end
  end

  describe '配列や繰り返し処理を理解する' do
    def test_繰り返し処理
      $stdout = StringIO.new
      [1, 2, 3].each { |i| p i * i }
      output = $stdout.string

      assert_equal "1\n" + "4\n" + "9\n", output
    end

    def test_selectメソッドで特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].select(&:integer?)
      assert_equal [2, 4], result
    end

    def test_find_allメソッドで特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].find_all(&:integer?)
      assert_equal [2, 4], result
    end

    def test_特定の条件を満たさない要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].reject(&:integer?)
      assert_equal [1.1, 3.3], result
    end

    def test_mapメソッドで新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].map(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_collectメソッドで新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].collect(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_findメソッドで配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].find(&:size)
      assert_equal 'apple', result
    end

    def test_detectメソッドで配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].detect(&:size)
      assert_equal 'apple', result
    end

    def test_指定した評価式で並び変えた配列を返す
      result1 = %w[2 4 13 3 1 10].sort
      result2 = %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i }
      result3 = %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i }

      assert_equal %w[1 10 13 2 3 4], result1
      assert_equal %w[1 2 3 4 10 13], result2
      assert_equal %w[13 10 4 3 2 1], result3
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry apricot].grep(/^a/)
      assert_equal %w[apple apricot], result
    end

    def test_ブロック内の条件式が真である間までの要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9].take_while { |item| item < 6 }
      assert_equal [1, 2, 3, 4, 5], result
    end

    def test_ブロック内の条件式が真である以降の要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].drop_while { |item| item < 6 }
      assert_equal [6, 7, 8, 9, 10], result
    end

    def test_injectメソッドで畳み込み演算を行う
      result = [1, 2, 3, 4, 5].inject(0) { |total, n| total + n }
      assert_equal 15, result
    end

    def test_reduceメソッドで畳み込み演算を行う
      result = [1, 2, 3, 4, 5].reduce { |total, n| total + n }
      assert_equal 15, result
    end
  end

  describe 'FizzBuzzValue' do
    def setup
      @fizzbuzz = FizzBuzzValueCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
    end

    def test_同じで値である
      value1 = @fizzbuzz.execute(1)
      value2 = @fizzbuzz.execute(1)

      assert value1.eql?(value2)
    end

    def test_to_stringメソッド
      value = @fizzbuzz.execute(3)

      assert_equal '3:Fizz', value.to_s
    end
  end

  describe 'FizzBuzzValueList' do
    def setup
      @fizzbuzz = FizzBuzzListCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
    end

    def test_新しいインスタンスが作られる
      list1 = @fizzbuzz.execute(50)
      list2 = list1.add(list1.value)

      assert_equal 50, list1.value.count
      assert_equal 100, list2.value.count
    end
  end
end

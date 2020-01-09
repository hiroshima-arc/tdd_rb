require 'minitest/autorun'
require_relative '../../fizz_buzz/application/service/fizz_buzz_service.rb'

class FizzBuzzServiceTest < Minitest::Test
  describe 'generate service' do
    def setup
      @service = FizzBuzz::Application::Service::FizzBuzzService.new
    end

    def test_1を渡したらFizzBuzzValueのJSONオブジェクトを返す
      result = @service.generate('1')
      assert_equal '{"number":1,"value":"1"}', result
    end

    def test_3を渡したらFizzBuzzValueのJSONオブジェクトを返す
      result = @service.generate('3')
      assert_equal '{"number":3,"value":"Fizz"}', result
    end

    def test_5を渡したらFizzBuzzValueのJSONオブジェクトを返す
      result = @service.generate('5')
      assert_equal '{"number":5,"value":"Buzz"}', result
    end

    def test_15を渡したらFizzBuzzValueのJSONオブジェクトを返す
      result = @service.generate('15')
      assert_equal '{"number":15,"value":"FizzBuzz"}', result
    end
  end

  describe 'generate list service' do
    describe 'タイプ1の場合' do
      def setup
        @service = FizzBuzz::Application::Service::FizzBuzzService.new
        @result = @service.generate_list('1', '100')
      end

      def test_100を渡したら100件のJSONオブジェクトを返す
        assert_equal 100, JSON.parse(@result)['data'].count
      end

      def test_100件のJSONオブジェクトの最初は1
        assert_equal '1', JSON.parse(@result)['data'].first
      end

      def test_100件のJSONオブジェクトの2番目はFizz
        assert_equal 'Fizz', JSON.parse(@result)['data'][2]
      end

      def test_100件のJSONオブジェクトの14番目はFizzBuzz
        assert_equal 'FizzBuzz', JSON.parse(@result)['data'][14]
      end

      def test_100件のJSONオブジェクトの最後はBuzz
        assert_equal 'Buzz', JSON.parse(@result)['data'].last
      end
    end

    describe 'タイプ2の場合' do
      def setup
        @service = FizzBuzz::Application::Service::FizzBuzzService.new
        @result = @service.generate_list('2', '100')
      end

      def test_100件のJSONオブジェクトの最初は1
        assert_equal '1', JSON.parse(@result)['data'].first
      end

      def test_100件のJSONオブジェクトの2番目は3
        assert_equal '3', JSON.parse(@result)['data'][2]
      end

      def test_100件のJSONオブジェクトの14番目は15
        assert_equal '15', JSON.parse(@result)['data'][14]
      end

      def test_100件のJSONオブジェクトの最後は100
        assert_equal '100', JSON.parse(@result)['data'].last
      end
    end

    describe 'タイプ3の場合' do
      def setup
        @service = FizzBuzz::Application::Service::FizzBuzzService.new
        @result = @service.generate_list('3', '100')
      end

      def test_100件のJSONオブジェクトの最初は1
        assert_equal '1', JSON.parse(@result)['data'].first
      end

      def test_100件のJSONオブジェクトの2番目は3
        assert_equal '3', JSON.parse(@result)['data'][2]
      end

      def test_100件のJSONオブジェクトの14番目はFizzBuzz
        assert_equal 'FizzBuzz', JSON.parse(@result)['data'][14]
      end

      def test_100件のJSONオブジェクトの最後は100
        assert_equal '100', JSON.parse(@result)['data'].last
      end
    end
  end
end

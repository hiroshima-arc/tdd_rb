require 'minitest/autorun'
require_relative '../../fizz_buzz/application/fizz_buzz_service.rb'

class FizzBuzzServiceTest < Minitest::Test
  describe 'generate service' do
    def setup
      @service = FizzBuzz::Application::FizzBuzzService.new
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
end

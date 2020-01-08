require 'minitest/autorun'
require_relative '../../fizz_buzz/application/fizz_buzz_service.rb'

class FizzBuzzServiceTest < Minitest::Test
  describe 'generate service' do
    def setup
      @service = FizzBuzz::Application::FizzBuzzService.new
    end

    def test_1を渡したらFizzBuzzValueを返す
      result = @service.generate('1')
      assert_equal '1', result.value
    end

    def test_3を渡したらFizzBuzzValueを返す
      result = @service.generate('3')
      assert_equal 'Fizz', result.value
    end

    def test_5を渡したらFizzBuzzValueを返す
      result = @service.generate('5')
      assert_equal 'Buzz', result.value
    end

    def test_15を渡したらFizzBuzzValueを返す
      result = @service.generate('15')
      assert_equal 'FizzBuzz', result.value
    end
  end
end

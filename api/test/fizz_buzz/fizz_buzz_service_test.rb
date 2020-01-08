require 'minitest/autorun'

class FizzBuzzServiceTest < Minitest::Test
  def setup
    @service = FizzBuzz::Application::FizzBuzzService.new
  end

  describe 'generate service' do
    def test_1を渡したらFizzBuzzValueを返す
      result = @service.generate(1)
      assert_equal '1', result.value
    end
  end
end

require 'cowsay'

Handler =
  Proc.new do |req, res|
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say('hello world', 'cow')
  end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world', greeting
  end
end

def greeting
  'hello world'
end

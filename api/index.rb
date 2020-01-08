require 'cowsay'
require_relative './FizzBuzz.rb'

Handler =
  Proc.new do |req, res|
    fizzbuzz =
      FizzBuzzListCommand.new(FizzBuzzType.create(FizzBuzzType::TYPE_01))
    result = fizzbuzz.execute(100)
    message = result.to_s
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say(message.to_s, 'cow')
  end

require 'cowsay'
require_relative './FizzBuzz.rb'

Handler =
  Proc.new do |req, res|
    fizzbuzz = FizzBuzz.new(1)
    message = fizzbuzz.generate_list
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say(message.to_s, 'cow')
  end

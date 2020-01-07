require 'cowsay'
require_relative './FizzBuzz.rb'

Handler =
  Proc.new do |req, res|
    message = FizzBuzz.generate_list
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say(message.to_s, 'cow')
  end

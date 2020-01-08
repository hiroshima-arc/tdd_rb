require 'cowsay'
require_relative './fizz_buzz/application/fizz_buzz_list_command.rb'
require_relative './fizz_buzz/domain/type/fizz_buzz_type.rb'
require_relative './fizz_buzz/domain/type/fizz_buzz_type_01.rb'

Handler =
  Proc.new do |req, res|
    fizzbuzz =
      FizzBuzz::Application::FizzBuzzListCommand.new(
        FizzBuzz::Domain::Type::FizzBuzzType.create(
          FizzBuzz::Domain::Type::FizzBuzzType::TYPE_01
        )
      )
    result = fizzbuzz.execute(100)
    message = result.to_s
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say(message.to_s, 'cow')
  end

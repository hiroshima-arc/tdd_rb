require 'json'
require_relative './fizz_buzz/application/fizz_buzz_service.rb'

Handler =
  Proc.new do |req, res|
    number = req.query['number']
    service = FizzBuzz::Application::FizzBuzzService.new
    result = service.generate(number)
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = result.to_json
  end

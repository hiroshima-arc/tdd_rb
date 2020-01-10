require_relative './fizz_buzz/application/service/fizz_buzz_service.rb'

Handler =
  Proc.new do |req, res|
    type = req.query['type']
    number = req.query['number']
    service = FizzBuzz::Application::Service::FizzBuzzService.new

    res.status = 200
    res['Access-Control-Allow-Origin'] = '*'
    res['Content-Type'] = 'text/plain'
    res.body = service.generate_list(type, number)
  end

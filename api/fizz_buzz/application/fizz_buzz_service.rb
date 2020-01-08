require_relative '../domain/model/fizz_buzz_value.rb'

module FizzBuzz
  module Application
    class FizzBuzzService
      def generate(number)
        FizzBuzz::Domain::Model::FizzBuzzValue.new(number, '1')
      end
    end
  end
end

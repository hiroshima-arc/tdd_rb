require_relative './fizz_buzz_type.rb'
require_relative '../model/fizz_buzz_value.rb'

module FizzBuzz
  module Domain
    module Type
      class FizzBuzzType02 < FizzBuzzType
        def generate(number)
          FizzBuzz::Domain::Model::FizzBuzzValue.new(number, number.to_s)
        end
      end
    end
  end
end

require_relative './fizz_buzz_type.rb'
require_relative '../model/fizz_buzz_value.rb'

module FizzBuzz
  module Domain
    module Type
      class FizzBuzzType03 < FizzBuzzType
        def generate(number)
          if is_fizz(number) && is_buzz(number)
            return(
              FizzBuzz::Domain::Model::FizzBuzzValue.new(number, 'FizzBuzz')
            )
          end
          FizzBuzz::Domain::Model::FizzBuzzValue.new(number, number.to_s)
        end
      end
    end
  end
end

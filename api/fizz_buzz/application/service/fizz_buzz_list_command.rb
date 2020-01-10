require_relative './fizz_buzz_command.rb'
require_relative '../../domain/model/fizz_buzz_list.rb'

module FizzBuzz
  module Application
    module Service
      class FizzBuzzListCommand < FizzBuzzCommand
        def initialize(type)
          @type = type
        end

        def execute(number)
          FizzBuzz::Domain::Model::FizzBuzzList.new(
            (1..number).map { |i| @type.generate(i) }
          )
        end
      end
    end
  end
end

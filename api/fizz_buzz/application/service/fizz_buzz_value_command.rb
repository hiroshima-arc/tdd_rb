require_relative './fizz_buzz_command.rb'

module FizzBuzz
  module Application
    module Service
      class FizzBuzzValueCommand < FizzBuzzCommand
        def initialize(type)
          @type = type
        end

        def execute(number)
          @type.generate(number)
        end
      end
    end
  end
end

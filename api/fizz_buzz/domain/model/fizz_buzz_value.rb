require 'json'

module FizzBuzz
  module Domain
    module Model
      class FizzBuzzValue
        attr_reader :number, :value

        def initialize(number, value)
          raise '正の値のみ有効です' if number.negative?

          @number = number
          @value = value
        end

        def as_json(options = {})
          { number: @number, value: @value }
        end

        def to_json(*options)
          as_json(*options).to_json(*options)
        end

        def to_s
          "#{@number}:#{@value}"
        end

        def ==(other)
          @number == other.number && @value == other.value
        end

        alias eql? ==
      end
    end
  end
end

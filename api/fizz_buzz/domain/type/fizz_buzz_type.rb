module FizzBuzz
  module Domain
    module Type
      class FizzBuzzType
        TYPE_01 = 1
        TYPE_02 = 2
        TYPE_03 = 3

        def self.create(type)
          case type
          when 1
            FizzBuzzType01.new
          when 2
            FizzBuzzType02.new
          when 3
            FizzBuzzType03.new
          else
            raise '該当するタイプは存在しません'
          end
        end

        def is_fizz(number)
          number.modulo(3).zero?
        end

        def is_buzz(number)
          number.modulo(5).zero?
        end
      end
    end
  end
end

# frozen_string_literal: true

class FizzBuzz
  MAX_NUMBER = 100
  attr_accessor :list

  def generate(number, type = 1)
    is_fizz = number.modulo(3).zero?
    is_buzz = number.modulo(5).zero?

    case type
    when 1
      return 'FizzBuzz' if is_fizz && is_buzz
      return 'Fizz' if is_fizz
      return 'Buzz' if is_buzz

      number.to_s
    when 2
      number.to_s
    when 3
      return 'FizzBuzz' if is_fizz && is_buzz

      number.to_s
    else
      raise '該当するタイプは存在しません'
    end
  end

  def generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    @list = (1..MAX_NUMBER).map { |n| generate(n) }
  end
end

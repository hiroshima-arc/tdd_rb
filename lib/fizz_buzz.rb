# frozen_string_literal: true

class FizzBuzz
  MAX_NUMBER = 100
  attr_reader :list

  def initialize(type)
    @type = FizzBuzz.create(type)
  end

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

  def generate(number)
    @type.generate(number)
  end

  def generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    @list = (1..MAX_NUMBER).map { |n| @type.generate(n) }
  end
end

class FizzBuzzType
  def is_fizz(number)
    number.modulo(3).zero?
  end

  def is_buzz(number)
    number.modulo(5).zero?
  end
end

class FizzBuzzType01 < FizzBuzzType
  def generate(number)
    return 'FizzBuzz' if is_fizz(number) && is_buzz(number)
    return 'Fizz' if is_fizz(number)
    return 'Buzz' if is_buzz(number)

    number.to_s
  end
end

class FizzBuzzType02 < FizzBuzzType
  def generate(number)
    number.to_s
  end
end

class FizzBuzzType03 < FizzBuzzType
  def generate(number)
    return 'FizzBuzz' if is_fizz(number) && is_buzz(number)

    number.to_s
  end
end

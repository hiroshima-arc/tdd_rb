# frozen_string_literal: true

class FizzBuzz
  MAX_NUMBER = 100
  attr_reader :list
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def generate(number)
    @type.generate(number)
  end

  def generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    @list = (1..MAX_NUMBER).map { |n| generate(n) }
  end
end

class FizzBuzzType
  TYPE_01 = 1
  TYPE_02 = 2
  TYPE_03 = 3

  def self.create(type)
    case type
    when FizzBuzzType::TYPE_01
      FizzBuzzType01.new
    when FizzBuzzType::TYPE_02
      FizzBuzzType02.new
    when FizzBuzzType::TYPE_03
      FizzBuzzType03.new
    else
      raise '該当するタイプは存在しません'
    end
  end

  def fizz?(number)
    number.modulo(3).zero?
  end

  def buzz?(number)
    number.modulo(5).zero?
  end
end

class FizzBuzzType01 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new(number, 'FizzBuzz') if fizz?(number) && buzz?(number)
    return FizzBuzzValue.new(number, 'Fizz') if fizz?(number)
    return FizzBuzzValue.new(number, 'Buzz') if buzz?(number)

    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType02 < FizzBuzzType
  def generate(number)
    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType03 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new(number, 'FizzBuzz') if fizz?(number) && buzz?(number)

    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzValue
  attr_reader :number, :value

  def initialize(number, value)
    @number = number
    @value = value
  end

  def to_s
    "#{@number}:#{@value}"
  end

  def ==(other)
    @number == other.number && @value == other.value
  end

  alias eql? ==
end

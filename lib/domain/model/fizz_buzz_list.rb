# frozen_string_literal: true

class FizzBuzzList
  MAX_COUNT = 100
  attr_reader :value

  def initialize(list)
    raise "上限は#{MAX_COUNT}件までです" if list.count > 100

    @value = list
  end

  def to_s
    @value.to_s
  end

  def add(value)
    FizzBuzzList.new(@value + value)
  end
end

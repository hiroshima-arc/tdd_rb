# frozen_string_literal: true

# Fibonacci calculator
class Fibonacci
  def self.calc(number, memo = {})
    return 0 if number.zero?
    return 1 if number <= 2

    memo[number] ||= calc(number - 1, memo) + calc(number - 2, memo)
  end
end

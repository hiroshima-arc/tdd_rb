# frozen_string_literal: true

# Fibonacci calculator
class Fibonacci
  def self.fib(number, memo = {})
    return 0 if number.zero?
    return 1 if number <= 2

    memo[number] ||= fib(number - 1, memo) + fib(number - 2, memo)
  end
end

# frozen_string_literal: true

module Fibonacci
  # Fibonacci Recursive algorithm
  class Recursive
    def calc(number, memo = {})
      return 0 if number.zero?
      return 1 if number == 1

      memo[number] ||= calc(number - 1, memo) + calc(number - 2, memo)
    end
  end
end

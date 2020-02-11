# frozen_string_literal: true

module Fibonacci
  # Fibonacci Calcultor
  class Command
    def initialize(algorithm)
      @algorithm = algorithm
    end

    def calc(number)
      @algorithm.calc(number)
    end
  end
end

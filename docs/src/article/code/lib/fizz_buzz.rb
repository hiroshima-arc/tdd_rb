class FizzBuzz
  MAX_NUMBER = 100

  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz
    number.to_s
  end

  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end

# frozen_string_literal: true

class Bank
  attr_reader :sum

  def initialize(sum)
    @sum = sum
  end

  def get_win(money)
    @sum += money
  end

  def place_bet(money)
    @sum -= money
  end
end

# frozen_string_literal: true

require_relative 'bank'

class GameBank < Bank
  def get_bets(money)
    @sum += money
  end

  def give_win(money)
    @sum -= money
  end
end

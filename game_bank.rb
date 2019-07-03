# frozen_string_literal: true

require_relative 'bank'

class GameBank < Bank
  def reward_winner(winner)
    winner.debit(@amount)
    @amount = 0
  end

  def make_bets(*players)
    players.each { |player| player.withdraw(10) }
    @amount = 20
  end

  def refund(*players)
    players.each { |player| player.debit(@amount / 2) }
    @amount = 0
  end
end

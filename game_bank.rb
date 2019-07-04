# frozen_string_literal: true

require_relative 'bank'

class GameBank < Bank
  def reward_winner(winner)
    winner.debit(amount)
    @amount = 0
  end

  def make_bets(*players)
    players.each do |player|
      player.withdraw(GameRules::BET_SIZE)
      debit(GameRules::BET_SIZE)
    end
  end

  def refund(*players)
    refund_amount = amount / players.size.to_f
    players.each { |player| player.debit(refund_amount) }
    @amount = 0
  end
end

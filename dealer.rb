# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  def can_take_card?
    !@hand.full? && @hand.count_sum < GameRules::DEALER_MAX_SUM
  end
end

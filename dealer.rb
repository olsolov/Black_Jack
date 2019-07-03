# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  def player_cards_hide
    @hand.player_cards_hide
  end

  def take_card?
    count_points < 17 && cards_size <= 3
  end
end

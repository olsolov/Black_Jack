# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  def show_cards_close
    puts('*' * @hand.size).to_s
  end
end

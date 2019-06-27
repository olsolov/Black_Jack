require_relative 'player'

class Dealer < Player
  def show_cards_close
    puts "#{'*' * @hand.size }"
  end
end
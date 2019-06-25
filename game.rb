# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Game
  print 'Введите ваше имя: '
  name = gets.strip.capitalize

  def start
    player = Player.new
    bank_player = Bank.new(100)
    player.add_bank(bank_player)
    deck = Deck.new
    2.times do
      deck.take_card
      took_card = deck.took_card
      player.add_card(took_card)
    end
  end
end

new_game = Game.new
new_game.start

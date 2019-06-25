# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Game
  def enter_name
    print 'Введите ваше имя: '
    @name = gets.strip.capitalize
  end

# rubocop: disable all
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

    print "#{@name}, ваши карты: "
    player.show_cards

    player.bank.place_bet(10)
    puts "Вы сделали ставку 10$"
  end
end
# rubocop: enable all

new_game = Game.new
new_game.enter_name
new_game.start

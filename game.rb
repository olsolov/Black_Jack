# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'

class Game
  print 'Введите ваше имя: '
  name = gets.strip.capitalize

  def start
    player = Player.new
    bank_player = Bank.new(100)
    player.add_bank(bank_player)
  end
end

new_game = Game.new
new_game.start

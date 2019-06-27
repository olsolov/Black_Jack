# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Game
  def enter_name
    print 'Введите ваше имя: '
    @name = gets.strip.capitalize
  end

  def create_player
    @player = Player.new
    bank_player = Bank.new(100)
    @player.add_bank(bank_player)
  end

# rubocop: disable all
  def start
    enter_name

    create_player

    deck = Deck.new
    2.times do
      deck.take_card
      took_card = deck.took_card
      @player.add_card(took_card)
    end

    print "#{@name}, ваши карты: "
    @player.show_cards

    @player.bank.place_bet(10)
    puts "Вы сделали ставку 10$"

    puts "Введите 1, если вы хотите пропустить ход"
    puts "Введите 2, если вы хотите открыть карты"
    puts "Введите 3, если вы хотите взять картy" if @player.hand.size == 2 

    player_choice = gets.to_i
    @points = 0

  def count_points
    @player.hand.each do |card|
      if card[0] =~ /[[:digit:]]/
        if card[0] == "1"
          @points += 10
        else
          @points += card[0].to_i
        end
      end

      if card[0] =~ /[[:alpha:]]/
        if card[0] == "A"
          @points += 11
        else
          @points += 10
        end
      end
      puts @points
    end
  end
  end

end
# rubocop: enable all

new_game = Game.new
new_game.start

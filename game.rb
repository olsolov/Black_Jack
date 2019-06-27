# frozen_string_literal: true

require_relative 'player'
require_relative 'dealer'
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

  def create_dealer
    @dealer = Dealer.new
    bank_dealer = Bank.new(100)
    @dealer.add_bank(bank_dealer)
  end


# rubocop: disable all
  def start
    enter_name

    create_player
    create_dealer

    deck = Deck.new
    2.times do
      deck.take_card
      took_card = deck.took_card
      @player.add_card(took_card)
    end

    2.times do
      deck.take_card
      took_card = deck.took_card
      @dealer.add_card(took_card)
    end

    print "#{@name}, ваши карты: "
    @player.show_cards

    print "Карты дилера: "
    @dealer.show_cards_close

    @player.bank.place_bet(10)
    puts 'Вы сделали ставку 10$'

    @player.count_points
    puts "Ваши очки: #{@player.points}"

    puts 'Введите 1, если вы хотите пропустить ход'
    puts 'Введите 2, если вы хотите открыть карты'
    puts 'Введите 3, если вы хотите взять картy' if @player.hand.size == 2 

    player_choice = gets.to_i

    if player_choice == 1
      # dealer.make_move
    elsif  player_choice == 2
      @player.show_cards
    elsif player_choice == 3
      return unless @player.hand.size == 2 
      deck.take_card
      took_card = deck.took_card
      @player.add_card(took_card)
    else
      puts 'Такого ответа нет'
    end
    @player.show_cards

  end

end
# rubocop: enable all

new_game = Game.new
new_game.start

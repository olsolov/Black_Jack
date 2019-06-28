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
    loop do
      enter_name

      create_player
      create_dealer

      @deck = Deck.new
      2.times do
        @deck.take_card
        took_card = @deck.took_card
        @player.add_card(took_card)
      end

      2.times do
        @deck.take_card
        took_card = @deck.took_card
        @dealer.add_card(took_card)
      end

      print "#{@name}, ваши карты: "
      @player.show_cards

      print "Карты дилера: "
      @dealer.show_cards_close
      @dealer.count_points

      @player.bank.place_bet(10)
      puts 'Вы сделали ставку 10$'

      @player.count_points
      puts "Ваши очки: #{@player.points}"

      step_1

      if @player.hand.size == 3 && @dealer.hand.size
        open_cards
      else
        step_1 unless @player_choice == 2
      end
    end
  end

  def step_1
    puts 'Введите 1, если вы хотите пропустить ход'
    puts 'Введите 2, если вы хотите открыть карты'
    puts 'Введите 3, если вы хотите взять картy' if @player.hand.size == 2

    @player_choice = gets.to_i

    if @player_choice == 1
      dealer_move if @dealer.points < 17

      print "Карты дилера: "
      @dealer.show_cards_close


    elsif @player_choice == 2
      open_cards
    elsif @player_choice == 3
      return unless @player.hand.size == 2 
      @deck.take_card
      took_card = @deck.took_card
      @player.add_card(took_card)

      @player.show_cards
      @player.count_points
      puts "Ваши очки: #{@player.points}"

      dealer_move if @dealer.points < 17

      print "Карты дилера: "
      @dealer.show_cards_close
    else
      puts 'Такого ответа нет'
    end
  end

  def dealer_move
    @deck.take_card
    took_card = @deck.took_card
    @dealer.add_card(took_card)
  end

  def open_cards
    print "#{@name}, ваши карты: "
    @player.show_cards
    puts "Ваши очки: #{@player.points}"

    print "Карты дилера: "
    @dealer.show_cards
    @dealer.count_points
    puts "Очки дилера: #{@dealer.points}"

    self.find_winner
  end

  def find_winner
    puts "--------------------------"
    puts "Вы выиграли!" if @player.points == 21 || @player.points < 21 && (@dealer.points < @player.points) || @dealer.points > 21
    puts "Дилер выиграл!" if @dealer.points == 21 || @dealer.points < 21 && (@player.points < @dealer.points) || @player.points > 21
    puts "Ничья!" if @player.points <= 21 && @dealer.points <= 21 && @player.points == @dealer.points 
    puts "Победителя нет" if @player.points > 21 && @dealer.points > 21
    puts "--------------------------"
  end
end
# rubocop: enable all

new_game = Game.new
new_game.start

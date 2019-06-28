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

  def start
    # enter_name

    create_player
    create_dealer

    @game_bank = Bank.new(0)

    loop do
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

      print 'Карты дилера: '
      @dealer.show_cards_close
      @dealer.count_points

      @dealer.bank.place_bet(10)
      @player.bank.place_bet(10)
      puts 'Вы сделали ставку 10$'
      @game_bank.add_money(20)

      @player.count_points
      puts "Ваши очки: #{@player.points}"

      step_1

      if @player.hand.size == 3 && @dealer.hand.size == @player.hand.size
        open_cards
        find_winner
        give_cash
        puts "У вас на счету: $ #{@player.bank.sum}"

      else
        step_1 unless @player_choice == 2
      end

      if @player.bank.sum.zero?
        puts 'На вашем счету $ 0, игра окончена'
        break
      end

      print 'Хотите сыграть ещё?(Y/N): '
      input = gets.strip.capitalize

      break if input == 'N'

      @player.clear_hand
      @dealer.clear_hand
    end
  end

  def step_1
    puts 'Введите 1, если вы хотите пропустить ход'
    puts 'Введите 2, если вы хотите открыть карты'
    puts 'Введите 3, если вы хотите взять картy' if @player.hand.size == 2

    @player_choice = gets.to_i

    if @player_choice == 1
      dealer_move if @dealer.points < 17

      print 'Карты дилера: '
      @dealer.show_cards_close

    elsif @player_choice == 2
      open_cards
      find_winner
      give_cash
      puts "У вас на счету: $ #{@player.bank.sum}"

    elsif @player_choice == 3
      return unless @player.hand.size == 2

      @deck.take_card
      took_card = @deck.took_card
      @player.add_card(took_card)

      @player.show_cards
      @player.count_points
      puts "Ваши очки: #{@player.points}"

      dealer_move if @dealer.points < 17

      print 'Карты дилера: '
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

    print 'Карты дилера: '
    @dealer.show_cards
    @dealer.count_points
    puts "Очки дилера: #{@dealer.points}"
  end

  def find_winner
    puts '--------------------------'
    if @player.points == 21 || @player.points < 21 && (@dealer.points < @player.points) || @player.points < 21 && @dealer.points > 21
      puts 'Вы выиграли!'
      @winner = @player
    elsif @dealer.points == 21 || @dealer.points < 21 && (@player.points < @dealer.points) || @dealer.points < 21 && @player.points > 21
      puts 'Дилер выиграл!'
      @winner = @dealer
    elsif @player.points <= 21 && @dealer.points <= 21 && @player.points == @dealer.points
      puts 'Ничья!'
      @winner = 'draw'
    else
      puts 'Победителя нет' # if @player.points > 21 && @dealer.points > 21
      @winner = nil
    end
    puts '--------------------------'
  end

  def give_cash
    if @winner == @player
      @game_bank.place_bet(20)
      @player.bank.add_money(20)
    elsif @winner == @dealer
      @game_bank.place_bet(20)
      @dealer.bank.add_money(20)
    elsif @winner == 'draw'
      sum = @game_bank.sum
      half_sum = sum / 2
      @game_bank.place_bet(sum)
      @player.bank.add_money(half_sum)
      @dealer.bank.add_money(half_sum)
    end
  end
end

new_game = Game.new
new_game.start

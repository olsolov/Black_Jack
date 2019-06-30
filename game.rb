# frozen_string_literal: true

require_relative 'player'
require_relative 'dealer'
require_relative 'bank'
require_relative 'game_bank'
require_relative 'deck'

class Game
  def run
    # enter name
    print 'Введите ваше имя: '
    @name = gets.strip.capitalize

    # create player, dealer and game bank
    @players = [@player = Player.new, @dealer = Dealer.new]
    @game_bank = GameBank.new(0)

    loop do
      # create deck and shuffle cards
      @deck = Deck.new
      @deck.cards.shuffle!

      # hand out 2 cards
      @players.each do |player|
        2.times { player.take_card(@deck) }
      end

      # show player's and dealer's cards
      print "#{@name}, ваши карты: "
      @player.show_cards
      print 'Карты дилера: '
      @dealer.show_cards_close

      # make bets
      @dealer.bank.place_bet(10)
      @player.bank.place_bet(10)
      puts 'Вы сделали ставку 10$'
      @game_bank.get_bets(20)

      # show player's points
      @player.count_points
      puts "Ваши очки: #{@player.points}"

      main_part_game

      if @player.bank.sum.zero?
        puts 'На вашем счету $ 0, игра окончена'
        break
      end

      if @dealer.bank.sum.zero?
        puts 'На счету дилера $ 0, вы выиграли!'
        break
      end

      print 'Хотите сыграть ещё?(Y/N): '
      input = gets.strip.capitalize

      break if input == 'N'

      @player.clear_hand
      @dealer.clear_hand
    end
  end

  def main_part_game
    loop do
      puts 'Введите 1, если вы хотите пропустить ход'
      puts 'Введите 2, если вы хотите открыть карты'
      puts 'Введите 3, если вы хотите взять картy' if @player.hand.size == 2

      @choice = gets.strip

      case @choice
      when '1'
        dealer_move
      when '2'
        game_result
        puts "У вас на счету: $ #{@player.bank.sum}"
        break
      when '3'
        @player.take_card(@deck)
        dealer_move
      else
        puts 'Такого ответа нет'
      end

      if @player.hand.size == 3 && @dealer.hand.size == 3
        game_result
        puts "У вас на счету: $ #{@player.bank.sum}"
        break
      end

      show_cards_player_dealer
    end
  end

  def show_cards_player_dealer
    print "#{@name}, ваши карты: "
    @player.show_cards

    @player.count_points
    puts "Ваши очки: #{@player.points}"

    print 'Карты дилера: '
    @dealer.show_cards_close
  end

  def dealer_move
    @dealer.count_points
    @dealer.take_card(@deck) if @dealer.points < 17 && @dealer.hand.size <= 3
  end

  def open_cards
    print "#{@name}, ваши карты: "
    @player.show_cards
    @player.count_points
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
    sum = @game_bank.sum
    case @winner
    when @player
      @game_bank.give_win(sum)
      @player.bank.get_win(sum)
    when @dealer
      @game_bank.give_win(sum)
      @dealer.bank.get_win(sum)
    when 'draw'
      half_sum = sum / 2
      @game_bank.give_win(sum)
      @player.bank.get_win(half_sum)
      @dealer.bank.get_win(half_sum)
    end
  end

  def game_result
    open_cards
    find_winner
    give_cash
  end
end

Game.new.run

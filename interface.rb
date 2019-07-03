# frozen_string_literal: true

require_relative 'player'

class Interface
  def enter_name
    print 'Введите имя: '
    gets.strip.capitalize
  end

  def show_cards_points_player(player_cards, player_points)
    puts "Ваши карты: #{player_cards}, сумма очков: #{player_points}"
  end

  def show_cards_points_dealer(dealer_cards, dealer_points)
    puts "Карты дилера: #{dealer_cards}, сумма очков: #{dealer_points}"
  end

  def show_hide_cards_dealer(dealer_cards)
    puts "Карты дилера: #{dealer_cards}"
  end

  def bet_message
    puts 'Вы сделали ставку 10$.'
  end

  def amount_message(player_amount, dealer_amount)
    puts "На вашем счету: #{player_amount}$. На счету дилера: #{dealer_amount}$."
  end

  def action_menu(two_cards_in_hand)
    puts 'Введите 1, если вы хотите пропустить ход'
    puts 'Введите 2, если вы хотите открыть карты'
    puts 'Введите 3, если вы хотите взять картy' if two_cards_in_hand
    gets.to_i
  end

  def no_answer
    puts 'Такого ответа нет'
  end

  def show_winner(winner)
    case winner
    when :none
      puts 'Победителя нет'
    when :draw
      puts 'Ничья!'
    when :player
      puts 'Вы выиграли!'
    when :dealer
      puts 'Дилер выиграл!'
    end
  end

  def dealer_bankrupt_message
    puts 'На счету дилера 0$, вы выиграли!'
  end

  def offer_play
    print 'Хотите сыграть ещё?(Y/N): '
    gets.strip.capitalize
  end
end

# frozen_string_literal: true

require_relative 'player'

class Interface
  def enter_name
    print 'Введите имя: '
    gets.strip.capitalize
  end

  def show_sum(player_name, sum)
    puts "Cумма очков #{player_name}: #{sum}"
  end

  def show_cards(player_name, cards)
    opened_cards = cards.map { |card| "#{card.rank}#{card.suit}" }
    puts "Карты #{player_name}: #{opened_cards}"
  end

  def show_hidden_cards(player_name, count)
    cards_mask = Array.new(count, '*').join(' ')
    puts "Карты #{player_name}: #{cards_mask}"
  end

  def bet_message
    puts 'Вы сделали ставку 10$.'
  end

  def amount_message(player_amount, dealer_amount)
    puts "На вашем счету: #{player_amount}$. На счету дилера: #{dealer_amount}$."
  end

  def action_menu(can_take_card)
    puts 'Введите 1, если вы хотите пропустить ход'
    puts 'Введите 2, если вы хотите открыть карты'
    puts 'Введите 3, если вы хотите взять картy' if can_take_card
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

  def show_error(error_message)
    puts error_message
  end
end

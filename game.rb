# frozen_string_literal: true

require_relative 'interface'
require_relative 'player'
require_relative 'dealer'
require_relative 'bank'
require_relative 'game_bank'
require_relative 'deck'

class Game
  def initialize
    @interface = Interface.new
    @player = Player.new(@interface.enter_name)
    @dealer = Dealer.new('Dealer')
    @game_bank = GameBank.new(0)
    run
  end

  def get_start_cards(*players)
    players.each do |player|
      2.times { player.take_card(@deck) }
    end
  end

  def run
    @deck = Deck.new
    loop do
      # hand out 2 cards
      get_start_cards(@player, @dealer)

      # show player's and dealer's hide cards
      show_cards_player_dealer

      # make bets
      begin
        @game_bank.make_bets(@player, @dealer)
      rescue RuntimeError => e
        puts e.message
        break
      end

      @interface.bet_message
      @interface.amount_message(@player.amount, @dealer.amount)

      main_part_game

      if @dealer.amount.zero?
        @interface.dealer_bankrupt_message
        break
      end

      # offer to play more
      choice = @interface.offer_play
      break if choice == 'N'

      # # remove cards from hand before the next game
      @player.clear_hand
      @dealer.clear_hand
    end
  end

  def main_part_game
    loop do
      # prompt the player to choose an action
      choice = @interface.action_menu(@player.two_cards?)

      case choice
      when 1
        dealer_move
      when 2
        game_result
        @interface.amount_message(@player.amount, @dealer.amount)
        break
      when 3
        @player.take_card(@deck)
        dealer_move
      else
        @interface.no_answer
      end

      # automatic opening of cards if there are 3
      if @player.cards_size == 3 && @dealer.cards_size == 3
        game_result
        @interface.amount_message(@player.amount, @dealer.amount)
        break
      end

      # show player's and dealer's hide cards
      show_cards_player_dealer
    end
  end

  def show_cards_player_dealer
    @interface.show_cards_points_player(@player.player_cards, @player.count_points)
    @interface.show_hide_cards_dealer(@dealer.player_cards_hide)
  end

  def dealer_move
    @dealer.count_points
    @dealer.take_card(@deck) if @dealer.take_card?
  end

  def open_cards
    @interface.show_cards_points_player(@player.player_cards, @player.count_points)
    @interface.show_cards_points_dealer(@dealer.player_cards, @dealer.count_points)
  end

  def find_winner
    player_points = @player.count_points
    dealer_points = @dealer.count_points
    if player_points > 21 && dealer_points > 21
      return :none
    elsif player_points <= 21 && dealer_points <= 21 && player_points == dealer_points
      return :draw
    elsif player_points == 21 && dealer_points < 21 || dealer_points > 21
      return :player
    elsif player_points < 21 && dealer_points < player_points || dealer_points > 21
      return :player
    elsif dealer_points == 21 && player_points < 21 || player_points > 21
      return :dealer
    elsif dealer_points < 21 && player_points < dealer_points || player_points > 21
      return :dealer
    end
  end

  def give_cash(winner)
    case winner
    when :draw
      @game_bank.refund(@player, @dealer)
    when :player
      @game_bank.reward_winner(@player)
    when :dealer
      @game_bank.reward_winner(@dealer)
    end
  end

  def game_result
    open_cards
    @interface.show_winner(find_winner)
    give_cash(find_winner)
  end
end

Game.new

# frozen_string_literal: true

require_relative 'interface'
require_relative 'player'
require_relative 'dealer'
require_relative 'bank'
require_relative 'game_bank'
require_relative 'deck'
require_relative 'game_rules'

class Game
  include GameRules

  def initialize
    @interface = Interface.new
    @player = Player.new(@interface.enter_name)
    @dealer = Dealer.new('Dealer')
    @game_bank = GameBank.new(0)
    run
  end

  def get_start_cards(*players)
    players.each do |player|
      2.times { player.take_card(@deck.deal_card) }
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
        @interface.show_error(e.message)
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

      # remove cards from hand before the next game
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
        @player.take_card(@deck.deal_card)
        dealer_move
      else
        @interface.no_answer
      end

      # automatic opening of cards if there are 3
      if !@player.can_take_card? && !@dealer.can_take_card?
        game_result
        @interface.amount_message(@player.amount, @dealer.amount)
        break
      end

      # show player's and dealer's hide cards
      show_cards_player_dealer
    end
  end

  def show_cards_player_dealer
    @interface.show_cards(@player.name, @player.player_cards)
    @interface.show_sum(@player.name, @player.count_sum)
    @interface.show_hidden_cards(@dealer.name, @dealer.player_cards.size)
  end

  def dealer_move
    @dealer.count_sum
    @dealer.take_card(@deck.deal_card) if @dealer.can_take_card?
  end

  def open_cards
    @interface.show_cards(@player.name, @player.player_cards)
    @interface.show_sum(@player.name, @player.count_sum)
    @interface.show_cards(@dealer.name, @dealer.player_cards)
    @interface.show_sum(@dealer.name, @dealer.count_sum)
  end

  def find_winner
    player_sum = @player.count_sum
    dealer_sum = @dealer.count_sum
    if player_sum > GameRules::BJ && dealer_sum > GameRules::BJ
      return :none
    elsif player_sum <= GameRules::BJ && dealer_sum <= GameRules::BJ && player_sum == dealer_sum
      return :draw
    elsif player_sum == GameRules::BJ && dealer_sum < GameRules::BJ || dealer_sum > GameRules::BJ
      return :player
    elsif player_sum < GameRules::BJ && dealer_sum < player_sum || dealer_sum > GameRules::BJ
      return :player
    elsif dealer_sum == GameRules::BJ && player_sum < GameRules::BJ || player_sum > GameRules::BJ
      return :dealer
    elsif dealer_sum < GameRules::BJ && player_sum < dealer_sum || player_sum > GameRules::BJ
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

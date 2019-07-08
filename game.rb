# frozen_string_literal: true

require_relative 'interface'
require_relative 'player'
require_relative 'dealer'
require_relative 'bank'
require_relative 'game_bank'
require_relative 'deck'
require_relative 'game_rules'

class Game
  PLAYER_ACTIONS = {
    skip: 1,
    open_cards: 2,
    add_card: 3
  }.freeze

  ROUND_RESULTS = {
    draw: 1,
    player_won: 2,
    dealer_won: 3
  }.freeze

  include GameRules

  def initialize
    @interface = Interface.new
    @player = Player.new(@interface.enter_name)
    @dealer = Dealer.new('Dealer')
    @game_bank = GameBank.new(0)
    run
  end

  def run
    loop do
      reset_state
      get_start_cards(@player, @dealer)
      show_cards_player_dealer
      make_bets
      play_round
      round_results
      check_dealer_balance!
      break unless continue_game?
    end
  rescue RuntimeError => e
    @interface.show_error(e.message)
  end

  private

  def reset_state
    @deck = Deck.new
    @player.clear_hand
    @dealer.clear_hand
  end

  def get_start_cards(*players)
    players.each do |player|
      2.times { player.add_card(@deck.deal_card) }
    end
  end

  def show_cards_player_dealer
    @interface.show_cards(@player.name, @player.cards)
    @interface.show_sum(@player.name, @player.count_sum)
    @interface.show_hidden_cards(@dealer.name, @dealer.cards.size)
  end

  def make_bets
    @game_bank.make_bets(@player, @dealer)
    @interface.bet_message
    @interface.amount_message(@player.amount, @dealer.amount)
  end

  def play_round
    loop do
      choice = @interface.action_menu(@player.can_take_card?)
      break if choice == PLAYER_ACTIONS[:open_cards]

      player_turn(choice)
      dealer_turn
      break unless players_have_moves?

      show_cards_player_dealer
    end
  end

  def player_turn(choice)
    if choice == PLAYER_ACTIONS[:skip]
      dealer_turn
    elsif choice == PLAYER_ACTIONS[:add_card]
      @player.add_card(@deck.deal_card)
    else
      @interface.no_answer
    end
  end

  def dealer_turn
    @dealer.count_sum
    @dealer.add_card(@deck.deal_card) if @dealer.can_take_card?
  end

  def players_have_moves?
    @player.can_take_card? || @dealer.can_take_card?
  end

  def open_cards
    @interface.show_cards(@player.name, @player.cards)
    @interface.show_sum(@player.name, @player.count_sum)
    @interface.show_cards(@dealer.name, @dealer.cards)
    @interface.show_sum(@dealer.name, @dealer.count_sum)
  end

  def find_winner
    player_sum = @player.count_sum
    dealer_sum = @dealer.count_sum
    if player_sum > GameRules::BJ && dealer_sum > GameRules::BJ
      ROUND_RESULTS[:draw]
    elsif player_sum == dealer_sum
      ROUND_RESULTS[:draw]
    elsif player_sum > GameRules::BJ
      ROUND_RESULTS[:dealer_won]
    elsif dealer_sum > GameRules::BJ
      ROUND_RESULTS[:player_won]
    elsif dealer_sum > player_sum
      ROUND_RESULTS[:dealer_won]
    elsif player_sum > dealer_sum
      ROUND_RESULTS[:player_won]
    end
  end

  def give_cash(round_result)
    case round_result
    when ROUND_RESULTS[:draw]
      @game_bank.refund(@player, @dealer)
    when ROUND_RESULTS[:player_won]
      @game_bank.reward_winner(@player)
    when ROUND_RESULTS[:dealer_won]
      @game_bank.reward_winner(@dealer)
    end
  end

  def round_results
    open_cards
    @interface.show_winner(find_winner)
    give_cash(find_winner)
    @interface.amount_message(@player.amount, @dealer.amount)
  end

  def check_dealer_balance!
    @interface.dealer_bankrupt_message if @dealer.amount.zero?
    exit if @dealer.amount.zero?
  end

  def continue_game?
    choice = @interface.offer_play
    choice == 'Y'
  end
end

Game.new

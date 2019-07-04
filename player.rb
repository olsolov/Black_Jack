# frozen_string_literal: true

require_relative 'bank'
require_relative 'hand'
require_relative 'game_rules'

class Player
  include GameRules
  attr_reader :name, :hand, :bank

  def initialize(name)
    @name = name
    @hand = Hand.new
    @bank = Bank.new(GameRules::PLAYER_BANK_INIT_AMOUNT)
  end

  def take_card(card)
    @hand.add_card(card)
  end

  def player_cards
    @hand.cards
  end

  def two_cards?
    @hand.two_cards?
  end

  def can_take_card?
    !@hand.full?
  end

  def full?
    @hand.full?
  end

  def count_sum
    @hand.count_sum
  end

  def amount
    @bank.amount
  end

  def debit(amount)
    @bank.debit(amount)
  end

  def withdraw(amount)
    @bank.withdraw(amount)
  end

  def clear_hand
    @hand.clear_hand
  end
end

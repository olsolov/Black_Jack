# frozen_string_literal: true

require_relative 'bank'
require_relative 'hand'

class Player
  attr_reader :name, :hand, :bank, :took_card

  def initialize(name)
    @name = name
    @hand = Hand.new
    @bank = Bank.new(100)
  end

  def take_card(deck)
    @took_card = deck.cards[0]
    @hand.cards << @took_card
    deck.cards.delete(@took_card)
  end

  def player_cards
    @hand.player_cards
  end

  def two_cards?
    @hand.two_cards?
  end

  def cards_size
    @hand.cards_size
  end

  def count_points
    @hand.count_points
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

# frozen_string_literal: true

require_relative 'bank'
require_relative 'hand'
require_relative 'game_rules'
require 'forwardable'

class Player
  include GameRules
  extend Forwardable

  attr_reader :name, :hand, :bank
  def_delegators :@hand, :cards, :add_card, :count_sum, :clear_hand
  def_delegators :@bank, :amount, :debit, :withdraw

  def initialize(name)
    @name = name
    @hand = Hand.new
    @bank = Bank.new(GameRules::PLAYER_BANK_INIT_AMOUNT)
  end

  def can_take_card?
    !@hand.full?
  end
end

# frozen_string_literal: true

require_relative 'game_rules'

class Bank
  include GameRules
  NOT_ENOUGH_MONEY = 'Недостаточно средств на счёте'

  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def debit(amount)
    @amount += amount
  end

  def withdraw(amount)
    raise NOT_ENOUGH_MONEY if @amount < amount

    @amount -= amount
  end
end

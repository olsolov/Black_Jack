# frozen_string_literal: true

class Bank
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def debit(amount)
    @amount += amount
  end

  def withdraw(amount)
    raise 'Недостаточно средств на счёте, чтобы сделать ставку' if @amount.zero?

    @amount -= amount
  end
end

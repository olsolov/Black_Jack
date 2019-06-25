# frozen_string_literal: true

class Player
  attr_reader :bank

  def initialize
    @hand = []
  end

  def add_bank(bank)
    @bank = bank
  end
end

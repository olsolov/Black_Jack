# frozen_string_literal: true

class Player
  attr_reader :bank, :hand

  def initialize
    @hand = []
  end

  def add_bank(bank)
    @bank = bank
  end

  def add_card(card)
    @hand << card
  end

  def show_cards
    @hand.each do |card|
      print "#{card} "
    end
    puts
  end

  def clear_hand
    @hand = []
  end
end

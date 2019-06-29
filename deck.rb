# frozen_string_literal: true

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    @card_value = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    @suits = ["\u2665".encode('utf-8'), "\u2666".encode('utf-8'), "\u2663".encode('utf-8'), "\u2660".encode('utf-8')]
    create_deck
  end

  def create_deck
    @suits.each do |suits|
      @card_value.each do |value|
        @cards << value + suits
      end
    end
  end
end

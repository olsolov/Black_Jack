# frozen_string_literal: true

require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    create_deck
  end

  def create_deck
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
    @cards.shuffle!
  end
end

# frozen_string_literal: true

class Card
  attr_reader :rank, :suit

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = ['♦', '♥', '♠', '♣'].freeze
  # VALUES = {2 => 2,
  #          3 => 3,
  #          4 => 4,
  #          5 => 5,
  #          6 => 6,
  #          7 => 7,
  #          8 => 8,
  #          9 => 9,
  #          10 => 10,
  #          'J' => 10,
  #          'Q' => 10,
  #          'K' => 10,
  #          'A' => 11}

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

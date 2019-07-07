# frozen_string_literal: true

require_relative 'card'
require_relative 'game_rules'

class Hand
  include GameRules
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def full?
    @cards.size == GameRules::HAND_MAX_SIZE
  end

  def count_sum
    sum = @cards.map(&:value).sum
    @cards.each do |card|
      sum -= GameRules::ACE_ADJUSTMENT_SUM if card.ace? && sum > GameRules::BJ
    end
    sum
  end

  def clear_hand
    @cards.clear
  end
end

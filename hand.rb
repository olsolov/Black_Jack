# frozen_string_literal: true

require_relative 'card'

class Hand
  attr_reader :points, :cards

  def initialize
    @cards = []
  end

  def player_cards
    (cards.map { |card| "#{card.rank}#{card.suit}" }).join(' ')
  end

  def player_cards_hide
    cards.map { '*' }.join(' ')
  end

  def two_cards?
    @cards.size == 2
  end

  def cards_size
    @cards.size
  end

  def count_points
    @points = 0
    @cards.each do |card|
      if card.rank =~ /[[:digit:]]/
        @points += if card.rank == '1'
                     10
                   else
                     card.rank.to_i
                   end
      end

      next unless card.rank =~ /[[:alpha:]]/

      @points += if card.rank == 'A'
                   11
                 else
                   10
                 end

      count_aces.times { @points -= 10 if card.rank == 'A' && @points > 21 }
    end
    @points
  end

  def count_aces
    @cards.count { |card| card.rank == 'A' }
  end

  def clear_hand
    @cards.clear
  end
end

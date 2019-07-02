# frozen_string_literal: true

class Hand
  attr_reader :points, :cards

  def initialize
    @cards = []
    @points = 0
  end

  def player_cards
    (cards.map { |card| "#{card.rank}#{card.suit}" }).join(' ')
  end

  def count_points
    @cards.each do |card|
      if card[0] =~ /[[:digit:]]/
        @points += if card[0] == '1'
                     10
                   else
                     card[0].to_i
                   end
      end

      next unless card[0] =~ /[[:alpha:]]/

      @points += if card[0] == 'A'
                   11
                 else
                   10
                 end

      count_aces.times { @points -= 10 if card[0] == 'A' && @points > 21 }
    end
  end

  def count_aces
    @cards.count { |card| card[0] == 'A' }
  end
end

# frozen_string_literal: true

class Player
  attr_reader :bank, :hand, :points

  def initialize
    @hand = []
    @points = 0
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

  # rubocop: disable all
  def count_points
    @hand.each do |card|
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
    end
  end
  # rubocop: enable all

  def clear_hand
    @hand = []
  end
end

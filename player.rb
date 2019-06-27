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

  def count_points
    @hand.each do |card|
      if card[0] =~ /[[:digit:]]/
        if card[0] == "1"
          @points += 10
        else
          @points += card[0].to_i
        end
      end

      if card[0] =~ /[[:alpha:]]/
        if card[0] == "A"
          @points += 11
        else
          @points += 10
        end
      end
    end
  end

  def clear_hand
    @hand = []
  end
end

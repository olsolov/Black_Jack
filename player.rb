# frozen_string_literal: true

class Player
  attr_reader :bank, :hand, :points, :took_card

  def initialize
    @hand = []
  end

  def add_bank(bank)
    @bank = bank
  end

  def take_card(deck)
    @took_card = deck.cards[0]
    @hand << @took_card
    deck.cards.delete(@took_card)
  end

  def show_cards
    @hand.each do |card|
      print "#{card} "
    end
    puts
  end

  def count_points
    @points = 0
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

  def clear_hand
    @hand.clear
  end
end

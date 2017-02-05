require "byebug"
class Player
  attr_reader :end_turn, :temporary_hands
  attr_accessor :hand
  def initialize
    @hand = []
    @end_turn = false
    @temporary_hands = []
  end

  def blackjack?
    if @hand[0] == "A" && [10, "J", "Q", "K"].include?(@hand[1])
      true
    elsif @hand[1] == "A" && [10, "J", "Q", "K"].include?(@hand[0])
      true
    else
      false
    end
  end

  def hit(deck)
    @hand << deck.draw
  end

  def stand
    @end_turn = true
  end

  def next_hand
    @end_turn = false
    @hand = [@temporary_hands.shift]
  end

  def split
    @temporary_hands << @hand.pop
  end

  def double_down

  end

  def value
    sorted_hand = []
    aces = 0
    @hand.each do |card|
      card.to_s == "A" ? aces += 1 : sorted_hand << card
    end

    aces.times { sorted_hand << "A" }

    sorted_hand.inject(0) do |sum, card|
      if card.to_s == "A" && sum < 11
        sum + 11
      elsif card.to_s == "A" && sum >= 11
        sum + 1
      elsif "JQK".include?(card.to_s)
        sum + 10
      else
        sum + card.to_i
      end
    end
  end

  def bust?
    value > 21
  end

end

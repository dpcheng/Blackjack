class Dealer
  attr_reader :hand, :end_turn

  def initialize
    @hand = []
    @end_turn = false
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

  def find_move(deck)
    if value < 17 #|| (value == 17 && @hand.include?("A"))
      puts "\nDealer has " + @hand.to_s.colorize(:red) + " with a value of " + value.to_s.colorize(:red)
      sleep(1)
      hit(deck)
      puts "\nDealer draws a " + @hand[-1].to_s.colorize(:red)
      sleep(1)
    else
      stand
    end
  end

  def value
    temporary_hand = []
    aces = 0
    @hand.each do |card|
      card.to_s == "A" ? aces += 1 : temporary_hand << card
    end

    aces.times { temporary_hand << "A" }

    temporary_hand.inject(0) do |sum, card|
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
    value = @hand.inject(0) do |sum, card|
      if card.to_s == "A"
        sum + 1
      elsif "JQK".include?(card.to_s)
        sum + 10
      else
        sum + card
      end
    end

    value > 21
  end

end

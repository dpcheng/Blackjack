require "byebug"

class Deck
  attr_accessor :deck, :decks_amount

  def initialize(decks_amount = 2)
    @deck = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"] * decks_amount
    @deck.shuffle!
  end

  def draw
    @deck.shift
  end

end

class Dealer
  attr_accessor :hand, :end_turn

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
      puts "\nDealer has " + @hand.inspect + " with a value of #{value}"
      hit(deck)
      puts "Dealer draws a #{@hand[-1]}"
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

    value > 21 ? true : false
  end

end

class Player
  attr_accessor :hand, :end_turn

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

  def split

  end

  def double_down

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

    value > 21 ? true : false
  end

end

class Game
  attr_accessor :dealer

  def initialize(deck, dealer, player)
    @deck = deck
    @dealer = dealer
    @player = player
  end

  def play
    introduction
    loop do

      if @deck.deck.count < 10
        puts "Deck is reshuffled"
        @deck = Deck.new
      end

      puts "Dealing new hand..."
      deal

      puts "Dealer has #{@dealer.hand[0]} showing."
      if @dealer.value == 21 #&& @dealer.hand[0] != "A"
        puts "Dealer has blackjack"
        print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
        break if gets.chomp.downcase == "stop"
        system("clear")
        next
      end

      puts "\nYou have " + @player.hand.inspect
      puts "Value: #{@player.value}"

      if @player.value == 21
        puts "Winner Winner Chicken Dinner!"
        print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
        break if gets.chomp.downcase == "stop"
        system("clear")
        next
      end

      until @player.bust? || @player.end_turn
        puts "\nWhat would you like to do?"
        print "\"h\" for hit. \"s\" for stand. "
        case gets.chomp.downcase
        when "h"
          @player.hit(@deck)
          puts "\nYou drew a #{@player.hand[-1]}"
          puts "You have " + @player.hand.inspect
          puts "Value: #{@player.value}"
        when "s"
          @player.stand
        end
      end

      if @player.bust? == false
        @dealer.find_move(@deck) until @dealer.end_turn
      end
      winner

      print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
      break if gets.chomp.downcase == "stop"
      system("clear")

    end

  end

  def deal
    @player = Player.new
    @dealer = Dealer.new

    until @player.hand.count == 2
      @dealer.hit(@deck)
      @player.hit(@deck)
    end
  end

  def introduction
    system("clear")
    puts "Welcome to Blackjack!\n\n"
  end

  def winner
    puts "\nDealer has " + @dealer.hand.inspect + " with a value of #{@dealer.value}"
    if @player.bust?
      puts "You busted with a #{@player.value}"
    elsif @dealer.bust?
      puts "Dealer busted, you win!"
    elsif @dealer.value == @player.value
      puts "Your hand pushes"
    elsif @dealer.value > @player.value
      puts "Dealer wins with a #{@dealer.value}"
    else
      puts "You win this hand!"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new(Deck.new, Dealer.new, Player.new).play
end

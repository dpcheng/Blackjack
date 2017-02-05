require_relative "deck"
require_relative "player"
require_relative "dealer"
require "colorize"

class Game
  def initialize(deck, dealer, player)
    @deck = deck
    @dealer = dealer
    @player = player
    @player_total = []
  end

  def play
    introduction
    loop do

      shuffle_deck if @deck.deck.count < 10

      puts "Dealing new hand..."
      deal

      puts "Dealer has " + @dealer.hand[0].to_s.colorize(:red) + " showing."
      if @dealer.value == 21 #&& @dealer.hand[0] != "A"
        puts "Dealer has blackjack" + @dealer.hand.to_s.colorize(:red)
        print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
        break if gets.chomp.downcase == "stop"
        system("clear")
        next
      end

      puts "\nYou have " + @player.hand.to_s.colorize(:blue)
      puts "Value: " + @player.value.to_s.colorize(:blue)
      sleep(1)

      if @player.value == 21
        puts "Winner Winner Chicken Dinner!"
        print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
        break if gets.chomp.downcase == "stop"
        system("clear")
        next
      end

      player_makes_choice until @player.bust? || @player.end_turn
      @player_total << @player.value

      if @player.bust? == false
        @dealer.find_move(@deck) until @dealer.end_turn
      end
      winner
      @player_total = []
      print "\nPress enter for a new hand. Type \"stop\" to stop playing. "
      break if gets.chomp.downcase == "stop"
      system("clear")

    end

  end

  def player_makes_choice
    puts "\nWhat would you like to do?"
    print "\"h\" for hit. \"s\" for stand. \"sp\" for split. \"dd\" for double-down. "
    case gets.chomp.downcase
    when "h"
      @player.hit(@deck)
      player_last_card
    when "s"
      @player.stand
    when "dd"
      @player.hit(@deck)
      player_last_card
      @player.stand
    when "sp"
      if @player.hand.count == 2 && @player.hand[0] == @player.hand[1]
        @player.split
        until @player.temporary_hands.count == 0
          puts "\nNow playing " + (@player.temporary_hands.count + 1).to_s.colorize(:blue) + " hands"
          # puts "You have a " + @player.hand.to_s.colorize(:blue)
          # puts "Value: " + @player.value.to_s.colorize(:blue)
          # sleep(1)
          @player.hit(@deck)
          player_last_card
          player_makes_choice until @player.end_turn
          @player_total << @player.value
          @player.next_hand
        end
      end
    end
  end

  def player_last_card
    puts "\nYou drew a " + @player.hand[-1].to_s.colorize(:blue)
    puts "You have " + @player.hand.to_s.colorize(:blue)
    puts "Value: " + @player.value.to_s.colorize(:blue)
    sleep(1)
  end

  def shuffle_deck
    puts "Deck is reshuffled"
    @deck = Deck.new
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
    puts "\nDealer has " + @dealer.hand.to_s.colorize(:red) + " with a value of " + @dealer.value.to_s.colorize(:red)
    @player_total.each do |total|
      if total > 21
        puts "You busted with a " + @player.value.to_s.colorize(:blue)
      elsif @dealer.bust?
        puts "Dealer busted with a " + @dealer.value.to_s.colorize(:red) + ", you win!"
      elsif @dealer.value == total
        puts "Your hand pushes with a " + total.to_s.colorize(:blue)
      elsif @dealer.value > total
        puts "Dealer wins with a " + @dealer.value.to_s.colorize(:red)
      else
        puts "You win this hand with a " + total.to_s.colorize(:blue) + "!"
      end
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new(Deck.new, Dealer.new, Player.new).play
end

require_relative "deck"
require_relative "player"
require_relative "dealer"
require "colorize"

class Game
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

      puts "Dealer has " + @dealer.hand[0].to_s.colorize(:red) + " showing."
      if @dealer.value == 21 #&& @dealer.hand[0] != "A"
        puts "Dealer has blackjack"
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

      until @player.bust? || @player.end_turn
        puts "\nWhat would you like to do?"
        print "\"h\" for hit. \"s\" for stand. "
        case gets.chomp.downcase
        when "h"
          @player.hit(@deck)
          puts "\nYou drew a " + @player.hand[-1].to_s.colorize(:blue)
          puts "You have " + @player.hand.to_s.colorize(:blue)
          puts "Value: " + @player.value.to_s.colorize(:blue)
          sleep(1)
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
    puts "\nDealer has " + @dealer.hand.to_s.colorize(:red) + " with a value of " + @dealer.value.to_s.colorize(:red)
    if @player.bust?
      puts "You busted with a " + @player.value.to_s.colorize(:blue)
    elsif @dealer.bust?
      puts "Dealer busted, you win!"
    elsif @dealer.value == @player.value
      puts "Your hand pushes"
    elsif @dealer.value > @player.value
      puts "Dealer wins with a " + @dealer.value.to_s.colorize(:red)
    else
      puts "You win this hand!"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new(Deck.new, Dealer.new, Player.new).play
end

class Deck
  attr_reader :deck

  def initialize(decks_amount = 4)
    @deck = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"] * decks_amount
    @deck.shuffle!
  end

  def draw
    @deck.shift
  end

end

class Deck
  attr_reader :deck

  def initialize(decks_amount = 40)
    @deck = ["Q", "K"] * decks_amount
    @deck.shuffle!
  end

  def draw
    @deck.shift
  end

end

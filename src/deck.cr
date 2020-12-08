class Deck
  property cards : Array(Card)

  def initialize(@cards)
  end

  def shuffle
    cards.shuffle!
  end

  def draw
    cards.pop
  end

  def add_card(card)
    cards << card
  end
end
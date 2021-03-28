class DrawCardCommand < Red::Inputs::Command
  def initialize(@deck : Deck, @hand : Deck)
  end

  def execute(_game_object)
    Red::Sounds.enqueue("beep")
    unless @deck.cards.empty?
      @hand.add_card(@deck.draw)
    end
  end
end

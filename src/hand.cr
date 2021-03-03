require "./card"

class HandGameObject < Red::GameObjects::GameObject
  OFFSET = SF.vector2i(36 + 2,0)
  property deck : Deck
  property card_game_objects : Array(CardGameObject)
  property background : Red::Renderable

  def initialize(@position, @background, @deck, @render_order = 0)
    @card_game_objects = [] of CardGameObject
    @deck.cards.each_with_index do |card, index|
      @card_game_objects << CardGameObject.new(
        @position + (OFFSET * index), card, @render_order
      )
    end
  end

  def hitbox_contains?(point)
    background.hitbox_contains?(position, point)
  end

  def objects_at(point)
    intersecting_objects = [] of Red::GameObjects::GameObject
    @card_game_objects.each do |card|
      intersecting_objects << card if card.hitbox_contains?(point)
    end

    if hitbox_contains?(point)
      intersecting_objects << self
    end

    intersecting_objects
  end

  def quads
    quads = background.new_verticies(position)
    card_game_objects.each do |card|
      quads = quads + card.quads
    end
    quads
  end

  def start_animation(_animation_key) ; end

  def update
    # most often the cards will be exactly the same from update to update
    # unless you've got wicked fast hands
    # When an update does happen, we expect the previous cards not to reorder
    indexes_changed = false
    deck.cards.each_with_index do |card, index|
      while @card_game_objects.size > index && card_game_objects[index] != card
        @card_game_objects.delete_at(index)
        indexes_changed = true
      end
      if card_game_objects.size <= index
        card_game_objects << CardGameObject.new(
          position + (OFFSET * index), card, render_order
        )
      end
    end

    if indexes_changed
      card_game_objects.each_with_index do |card, index|
        card.position = position + (OFFSET * index)
      end
    end
  end
end
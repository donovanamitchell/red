require "./layer"

module Red
  module Graphics
    module Layers
      class DrawableLayer < Layer
        include SF::Drawable

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
          # @font = SF::Font.from_file("./assets/dondo.bdf")

          # # Create a text
          # @text = SF::Text.new("THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG", @font)
          # @text.character_size = 7
          # @text.color = SF::Color::Red
          # @text.set_position(25, 25)

          states.transform *= transform()
          objects.each do |game_object|
            target.draw(game_object) if game_object.is_a?(SF::Drawable)
          end
        end

        def update
          # NOOP
        end
      end
    end
  end
end

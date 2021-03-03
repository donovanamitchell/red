require "../renderables"
require "./game_object"

module Red
  module GameObjects
    class RenderableGameObject < GameObject
      property renderable : Renderables::Renderable

      def initialize(@position, @renderable, @render_order = 0)

      end

      def hitbox_contains?(point)
        @renderable.hitbox_contains?(position, point)
      end

      def objects_at(point)
        hitbox_contains?(point) ? [self] : [] of GameObject
      end

      # TODO: only get a new one when there's been a change
      def quads
        @renderable.new_verticies(position)
      end

      # TODO: Private, this should be triggered by updates to the state
      # TODO: What do when the key is not found?
      def start_animation(animation_key)
        @renderable.start_animation(animation_key)
      end

      def update
        renderable.next_frame
      end
    end
  end
end

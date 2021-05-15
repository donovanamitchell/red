require "./game_object"

module Red
  module GameObjects
    class NilGameObject < GameObject
      property position : SF::Vector2(Int32)
      property render_order : Int32

      def initialize
        @position = SF.vector2(-1,-1)
        @render_order = 0
      end

      def hitbox_contains?(point)
        false
      end

      def objects_at(point)
        [] of GameObject
      end

      def start_animation(_animation_key) ; end

      def update ; end
    end
  end
end

require "./game_object"

module Red
  module GameObjects
    abstract class DrawableGameObject < GameObject
      include SF::Drawable
      # Abstract classes shouldn't complain about initialization
      # https://github.com/crystal-lang/crystal/issues/2827
      def initialize(@position, @render_order)
      end

      abstract def hitbox_contains?(point)

      abstract def objects_at(point)

      abstract def start_animation(animation_key)

      abstract def update
    end
  end
end

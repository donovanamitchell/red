module Red
  module GameObjects
    abstract class GameObject
      property position : SF::Vector2(Int32)
      property render_order : Int32

      # Abstract classes shouldn't complain about initialization
      # https://github.com/crystal-lang/crystal/issues/2827
      private def initialize(@position, @render_order)
      end

      abstract def hitbox_contains?(point)

      abstract def objects_at(point)

      abstract def quads

      abstract def start_animation(animation_key)

      abstract def update
    end
  end
end

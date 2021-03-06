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

      # TODO: only on renderable
      abstract def start_animation(animation_key)

      abstract def update

      def quads
        [] of SF::Vertex
      end
    end
  end
end

module Red
  class ColoredRenderable < Renderable
    property colors : Hash(String, SF::Color)

    def initialize(@texture_name : String,
                  @default_animation_key : String,
                  @colors : Hash(String, SF::Color) )
      super(@texture_name, @default_animation_key)
    end

    def new_vertex(layer, corner, offset)
      SF::Vertex.new(
        SF.vector2(
          (corner[0] * layer.w) + offset.x,
          (corner[1] * layer.h) + offset.y
        ),
        tex_coords: SF.vector2(
          layer.x + (corner[0] * layer.w),
          layer.y + (corner[1] * layer.h)
        ),
        color: colors[layer.name] || SF::Color::White
      )
    end
  end
end

require "crsfml"
require "./texture_location"

class Renderable
  property position : SF::Vector2(Int32)
  property texture_name : String
  property rectangle : SF::IntRect

  def initialize(@position : SF::Vector2, @texture_name : String, @texture_location : TextureLocation)
    @verticies = [] of SF::Vertex
    @rectangle = SF::IntRect.new(
      @position, SF.vector2i(@texture_location.w, @texture_location.h)
    )
  end

  # Assumes hitbox is whole texture
  def hitbox_contains?(point : SF::Vector2)
    @rectangle.contains?(point)
  end

  def new_quad
    @verticies.clear

    [[0, 0], [1, 0], [1, 1], [0, 1]].each do |corner|
      @verticies.push(
        new_vertex(corner, @position)
      )
    end

    @verticies
  end

  def new_vertex(corner, offset)
    SF::Vertex.new(
      SF.vector2(
        (corner[0] * @texture_location.w) + offset.x,
        corner[1] * @texture_location.h + offset.y
      ),
      tex_coords: SF.vector2(
        @texture_location.x + (corner[0] * @texture_location.w),
        @texture_location.y + (corner[1] * @texture_location.h)
      )
    )
  end
end

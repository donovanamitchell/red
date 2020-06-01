require "crsfml"
require "./animation_frame"

# TODO: Add a subclass for unanimated things?
# Also rename to Animations?
class Renderable
  property texture_name : String # TODO: REMOVE

  def initialize(@texture_name : String,
                 @animation_frame : AnimationFrame)
    @verticies = [] of SF::Vertex
  end

  # TODO: should know about all the related animations
  # TODO: subclass for static renderables
  def next_frame
  end

  # TODO: should know about all the related animations
  def start_animation(animation_key : String)
  end

  # Assumes hitbox is whole texture
  def hitbox_contains?(position : SF::Vector2, point : SF::Vector2)
    SF::IntRect.new(
      position, SF.vector2i(@animation_frame.w, @animation_frame.h)
    ).contains?(point)
  end

  def new_quad(position)
    @verticies.clear

    [[0, 0], [1, 0], [1, 1], [0, 1]].each do |corner|
      @verticies.push(
        new_vertex(corner, position)
      )
    end

    @verticies
  end

  def new_vertex(corner, offset)
    SF::Vertex.new(
      SF.vector2(
        (corner[0] * @animation_frame.w) + offset.x,
        corner[1] * @animation_frame.h + offset.y
      ),
      tex_coords: SF.vector2(
        @animation_frame.x + (corner[0] * @animation_frame.w),
        @animation_frame.y + (corner[1] * @animation_frame.h)
      )
    )
  end
end

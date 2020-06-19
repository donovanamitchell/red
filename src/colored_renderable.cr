class ColoredRenderable < Renderable
  property color : SF::Color

  def initialize(@texture_name : String,
                 @default_animation_key : String,
                 @color : SF::Color)
    super(@texture_name, @default_animation_key)
  end

  def new_vertex(corner, offset)
    SF::Vertex.new(
      SF.vector2(
        (corner[0] * @animation_frame.w) + offset.x,
        (corner[1] * @animation_frame.h) + offset.y
      ),
      tex_coords: SF.vector2(
        @animation_frame.x + (corner[0] * @animation_frame.w),
        @animation_frame.y + (corner[1] * @animation_frame.h)
      ),
      color: @color
    )
  end
end
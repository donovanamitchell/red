require "crsfml"
require "./animation_frame"

# TODO: Add a subclass for unanimated things?
# Also rename to Animations?
class Renderable
  property texture_name : String
  property animation_frame : AnimationFrame

  def initialize(@texture_name : String,
                 @default_animation_key : String)
    @verticies = [] of SF::Vertex
    @duration = 0
    @animation_key = @default_animation_key
    @frame_index = 0
    @animation_frame = AnimationLibrary.assets[@texture_name].animations[@animation_key].frames.first
  end

  # TODO: should know about all the related animations
  # TODO: subclass for static renderables
  def next_frame
    # 120 updates / second
    # 15 frames / second
    # 8 updates / frame
    return @duration += 1 unless @duration >= (UPDATES_PER_SECOND / ANIMATION_FRAMERATE)
    animation = AnimationLibrary.assets[@texture_name].animations[@animation_key]
    @frame_index = @frame_index + 1

    if animation.frames.size <= @frame_index
      start_animation(@default_animation_key)
    else
      @animation_frame = animation.frames[@frame_index]
      @duration = 0
    end
  end

  # TODO: should know about all the related animations
  def start_animation(animation_key : String)
    @duration = 0
    @frame_index = 0
    @animation_key = animation_key
    @animation_frame = AnimationLibrary.assets[@texture_name].animations[@animation_key].frames.first
  end

  def hitbox_contains?(position : SF::Vector2, point : SF::Vector2)
    SF::IntRect.new(
      position + @animation_frame.offset,
      SF.vector2i(@animation_frame.w, @animation_frame.h)
    ).contains?(point)
  end

  def new_quad(position)
    offset = position + @animation_frame.offset
    @verticies.clear

    [[0, 0], [1, 0], [1, 1], [0, 1]].each do |corner|
      @verticies.push(
        new_vertex(corner, offset)
      )
    end

    @verticies
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
      )
    )
  end
end

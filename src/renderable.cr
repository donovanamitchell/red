require "crsfml"
require "./animation_frame"

# TODO: Add a subclass for unanimated things?
# Also rename to Animations?
class Renderable
  MS_PER_UPDATE = 1000 / UPDATES_PER_SECOND

  property texture_name : String
  property animation_frame : AnimationFrame
  property remaining_ms : Float64

  def initialize(@texture_name : String,
                 @default_animation_key : String)
    @verticies = [] of SF::Vertex
    @animation_key = @default_animation_key
    @frame_index = 0
    @animation_frame = AnimationLibrary.assets[@texture_name].animations[@animation_key].frames.first
    @remaining_ms = @animation_frame.duration_ms.to_f
  end

  # TODO: subclass for static renderables
  # TODO: subclass for untrimmed renderables
  def next_frame
    @remaining_ms -= MS_PER_UPDATE
    # sometimes wait a cycle if updates per frame is an uneven number
    return unless @remaining_ms <= 0

    animation = AnimationLibrary.assets[@texture_name].animations[@animation_key]
    @frame_index = @frame_index + 1

    if animation.frames.size <= @frame_index
      start_animation(@default_animation_key)
    else
      @animation_frame = animation.frames[@frame_index]
      @remaining_ms += @animation_frame.duration_ms
    end
  end

  # perhaps change to queue animation?
  def start_animation(animation_key : String)
    @frame_index = 0
    @animation_key = animation_key
    @animation_frame = AnimationLibrary.assets[@texture_name].animations[@animation_key].frames.first
    @remaining_ms += @animation_frame.duration_ms
  end

  def hitbox_contains?(position : SF::Vector2, point : SF::Vector2)
    # TODO : move to animation frame, make property calculated from layers
    @animation_frame.contains?(position, point)
  end

  def new_verticies(position)
    @verticies.clear

    @animation_frame.layers.each do |layer|
      offset = position + layer.offset
      [[0, 0], [1, 0], [1, 1], [0, 1]].each do |corner|
        @verticies.push(
          new_vertex(layer, corner, offset)
        )
      end
    end

    @verticies
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
      )
    )
  end
end

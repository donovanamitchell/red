require "./nil_animation_frame"

module Red
  class NilRenderable < Renderable
    property texture_name : String
    property animation_frame : AnimationFrame
    property remaining_ms : Float64

    def initialize
      @texture_name = ""
      @verticies = [] of SF::Vertex
      @animation_frame = NilAnimationFrame.new
      @remaining_ms = Float64::INFINITY
      @default_animation_key = ""
      @animation_key = ""
      @frame_index = 0
    end

    def next_frame
      @remaining_ms
    end

    def start_animation(animation_key : String)
      # TODO: better errors
      raise "No animation with key '#{animation_key}' found"

      @remaining_ms
    end

    def hitbox_contains?(position : SF::Vector2, point : SF::Vector2)
      false
    end

    def new_verticies(position)
      @verticies
    end
  end
end

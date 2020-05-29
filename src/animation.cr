require "./animation_frame"
require "./texture_atlas_json_mapping"

class Animation
  getter frames

  def initialize()
    @frames = [] of AnimationFrame
  end

  def new_frame(order : Int32, sprite : TextureAtlasSprite)
    # TODO: put it in the right order
    # no guarantees around order except uniqueness
    raise "Unimplemented" if !@frames.empty? && @frames.last.order > order

    @frames.push(AnimationFrame.new(order, sprite))
  end
end

require "./animation_frame"
require "./texture_atlas_json_mapping"

class Animation
  getter frames

  def initialize()
    @frames = [] of AnimationFrame
  end

  def new_frame(order : Int32, sprite : TextureAtlasSprite)
    if !@frames.empty? && @frames.last.order > order
      # TODO: optimize? BST?
      index = @frames.index do |frame|
        frame.order > order
      end
      index ||= -1
      @frames.insert(index, AnimationFrame.new(order, sprite))
    else
      @frames.push(AnimationFrame.new(order, sprite))
    end
  end
end

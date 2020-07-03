class RecoloredRenderable < Renderable
  property colors : Hash(SF::Color, SF::Color)

  # TODO
  def initialize(@texture_name : String,
                 @default_animation_key : String,
                 @colors : Hash(SF::Color, SF::Color) )
    super(@texture_name, @default_animation_key)
  end
end
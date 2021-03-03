class AnimationCommand < Red::Inputs::Command
  def initialize(@animation_key : String)
  end

  def execute(game_object)
    game_object.start_animation(@animation_key)
  end
end
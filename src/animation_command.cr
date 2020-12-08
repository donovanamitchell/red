class AnimationCommand < Red::Command
  def initialize(@animation_key : String)
  end

  def execute(game_objects)
    game_objects.each &.start_animation(@animation_key)
  end
end
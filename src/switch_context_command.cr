class SwitchContextCommand < Red::Command
  def initialize(
    # What have I done?
    @set_context : Proc(Nil)
  )
  end

  def execute(_game_object)
    @set_context.call
  end
end

require "./command"

module Red
  class NilCommand < Command
    def execute(_game_object : GameObject) ; end
  end
end

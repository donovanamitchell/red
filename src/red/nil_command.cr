require "./command"

module Red
  class NilCommand < Command
    def execute(_game_objects : Array(GameObject)) ; end
  end
end

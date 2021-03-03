require "./command"

module Red
  module Inputs
    class NilCommand < Command
      def execute(_game_object : GameObject) ; end
    end
  end
end

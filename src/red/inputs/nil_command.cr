require "./command"
require "../game_objects"

module Red
  module Inputs
    class NilCommand < Command
      def execute(_game_object : GameObjects::GameObject) ; end
    end
  end
end

require "./nil_command"

module Red
  module Inputs
    class InputContext
      def initialize
        @mouse_registry = Hash(
          SF::Mouse::Button, Array(Command)
        ).new do |hash, key|
          hash[key] = [] of Command
        end
        @key_registry = Hash(
          SF::Keyboard::Key, Array(Command)
        ).new do |hash, key|
          hash[key] = [] of Command
        end
      end

      def handle(event)
        # TODO: Events registered to KeyReleased? Multiple commands from 1 event?
        case event
        when SF::Event::KeyReleased
          @key_registry[event.code]
        when SF::Event::MouseButtonReleased
          @mouse_registry[event.button]
        else
          [] of Command
        end
      end

      def register_key(key : SF::Keyboard::Key, command : Command)
        @key_registry[key] << command
      end

      def register_mouse(key : SF::Mouse::Button, command : Command)
        @mouse_registry[key] << command
      end
    end
  end
end

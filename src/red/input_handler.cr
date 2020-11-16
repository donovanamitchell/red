require "./nil_command"

module Red
  class InputHandler
    def initialize
      nil_command = NilCommand.new
      @input_registry = Hash(SF::Keyboard::Key, Command).new(nil_command)
    end

    def handle(event)
      @input_registry[event.code]
    end

    def register(key : SF::Keyboard::Key, command : Command)
      @input_registry[key] = command
    end
  end
end

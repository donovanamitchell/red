require "./nil_command"

module Red
  class InputContext
    def initialize
      nil_command = NilCommand.new
      # There is something incredibly wrong with having a key type of Class.
      # I've disgusted myself.
      @input_registry = Hash(SF::Event.class | SF::Keyboard::Key, Command).new(nil_command)
    end

    def handle(event)
      # TODO: Events registered to KeyReleased? Multiple commands from 1 event?
      if event.is_a?(SF::Event::KeyReleased)
        @input_registry[event.code]
      else
        @input_registry[event.class]
      end
    end

    def register(key : SF::Event.class | SF::Keyboard::Key, command : Command)
      @input_registry[key] = command
    end
  end
end

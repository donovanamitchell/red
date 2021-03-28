require "./sounds/bus"
require "./sounds/sound"
require "./sounds/registered_sound"
require "./sounds/deduped_sound"

module Red
  module Sounds
    @@audio_bus = Bus.new
    @@buffer_registry = Hash(String, SF::SoundBuffer).new

    def self.buffer_registry
      @@buffer_registry
    end

    def self.enqueue(sound : Sound)
      @@audio_bus.enqueue(sound)
    end

    def self.enqueue(sound_key : String)
      sound = RegisteredSound.new(@@buffer_registry[sound_key])
      @@audio_bus.enqueue(sound)
    end

    def self.register(key : String, buffer : SF::SoundBuffer)
      @@buffer_registry[key] = buffer
    end

    def self.update
      @@audio_bus.update
    end
  end
end

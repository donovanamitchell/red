module Red
  module Sounds
    class Bus
      property active_sounds
      property sound_queue

      def initialize
        @sound_queue = Deque(Sound).new
        @active_sounds = [] of Sound
      end

      def enqueue(sound : Sound)
        @sound_queue << sound
      end

      def update
        @active_sounds.reject! { |sound| sound.stopped? }

        while !@sound_queue.empty?
          sound = @sound_queue.shift
          if sound.enqueue?(@active_sounds)
            sound.play
            @active_sounds << sound
          end
        end
      end
    end
  end
end

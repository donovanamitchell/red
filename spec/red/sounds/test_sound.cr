module Red
  module Sounds
    class TestSound < Sound
      property enqueue : Proc(Array(Sound), Bool)
      property paused : Proc(Bool)
      property playing : Proc(Bool)
      property stopped : Proc(Bool)
      property times_play_called : Int32

      def initialize
        @enqueue = ->(_sounds : Array(Sound)) { true }
        @paused = -> { false }
        @playing = -> { true }
        @sound_source = SF::Sound.new
        @stopped = -> { false }
        @times_play_called = 0
      end

      def enqueue?(active_sounds)
        @enqueue.call(active_sounds)
      end

      def paused?
        @paused.call
      end

      def play
        @times_play_called += 1
      end

      def playing?
        @playing.call
      end

      def stopped?
        @stopped.call
      end
    end
  end
end

require "crsfml"
require "json"
require "log"
require "./red/animation_library"
require "./window_controller"

# 1 second = 1_000_000_000 nanoseconds
UPDATES_PER_SECOND = 120
TIME_PER_UPDATE = Time::Span.new(nanoseconds: 1_000_000_000 // UPDATES_PER_SECOND)
ANIMATION_FRAMERATE = 12

module Red
  VERSION = "0.0.1"

  Log.builder.bind "*", :debug, Log::IOBackend.new
  Dir.mkdir("./logs") unless Dir.exists?("./logs")
  Log.builder.bind "*", :debug, Log::IOBackend.new(
    File.new("./logs/#{Time.utc.to_s("%Y%m%d%H%M%S")}", "w+")
  )

  window_width = 248
  window_height = 220

  view_multiplier = 4

  # TODO: Better error messages and not here
  raise "Shaders not supported" unless SF::Shader.available?

  controller = WindowController.new(window_width, window_height, view_multiplier)
  controller.open()
end

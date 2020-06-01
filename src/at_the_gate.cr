require "crsfml"
require "json"
require "log"
require "./animation_library"
require "./window_controller"

module AtTheGate
  VERSION = "0.0.1"

  Log.builder.bind "*", :debug, Log::IOBackend.new
  Dir.mkdir("./logs") unless Dir.exists?("./logs")
  Log.builder.bind "*", :debug, Log::IOBackend.new(
    File.new("./logs/#{Time.utc.to_s("%Y%m%d%H%M%S")}", "w+")
  )

  window_width = 248
  window_height = 220

  view_multiplier = 2

  controller = WindowController.new(window_width, window_height, view_multiplier)
  controller.open()
end

require "crsfml"
require "./window_controller"
require "./animation_library"

module AtTheGate
  VERSION = "0.0.1"
  window_width = 248
  window_height = 220

  view_multiplier = 2

  controller = WindowController.new(window_width, window_height, view_multiplier)
  controller.open()
end

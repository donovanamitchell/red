module Red
  # https://gameprogrammingpatterns.com/command.html
  abstract class Command
    abstract def execute(game_object : GameObject)
  end
end

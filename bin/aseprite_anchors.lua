-- C:/Users\donov\AppData\Roaming\Aseprite\scripts\pivot_export.lua
-- https://community.aseprite.org/t/how-do-others-handle-json-manipulation/4011
-- https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

-- why is this shit not built in?
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
function split(inputstr, sep)
  sep=sep or '%s'
  local t={}
  for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
    table.insert(t,field)
    if s=="" then
      return t
    end
  end
end

function hex_to_rgb(hex)
  hex = hex:gsub("#","")
  return app.pixelColor.rgba(
    tonumber("0x"..hex:sub(1,2)),
    tonumber("0x"..hex:sub(3,4)),
    tonumber("0x"..hex:sub(5,6))
  )
end

local json = dofile("./json.lua")

local path, filename_with_extension, extension = string.match(app.params["filename"], "(.-)([^/]-([^%.]+))$")
local name_without_extension = filename_with_extension:match("(.+)%..+")
local sprite = app.open(app.params["filename"])
local layer_name = app.params["layer"]
local layer = false
local input = app.params["input"]
local output = app.params["output"]
local colormap = split(app.params["colormap"], ",")
local colorhash = {}
for i,color in ipairs(colormap) do
  if(i % 2 == 0) then
    colorhash[hex_to_rgb(colormap[i-1])]=colormap[i]
  end
end

local atlas_json = json.parse(io.open(input, "r"):read("*a"))
local background_color = app.pixelColor.rgba(0,0,0,0)

for i,l in ipairs(sprite.layers) do
  if(l.name == layer_name) then
    layer = l
  end
end

local count = 0

if layer == false then
  error(layer_name .. " layer not found in " .. name_without_extension)
end

for i,frame in ipairs(atlas_json["frames"]) do
  -- file, tag, index
  filename_split = split(frame["filename"], "/")
  frame_order = tonumber(filename_split[3]) + 1
  if(filename_split[1] == name_without_extension) then
    cel = layer:cel(frame_order)
    image = cel.image

    for x=0, image.width - 1 do
      for y=0, image.height - 1 do
        pixel = image:getPixel(x,y)
        if(pixel ~= background_color) then
          if(frame["anchors"] == nil) then
            frame["anchors"] = {}
          end
          table.insert(frame["anchors"],
            {
              ["x"]= x + cel.position.x,
              ["y"]= y + cel.position.y,
              ["name"]= colorhash[pixel] or pixel
            }
          )
        end
      end
    end
  end
  -- set frame order
  frame["frame_order"] = frame_order
  -- set filename
  frame["filename"] = filename_split[1]
  -- set tag
  frame["tag"] = filename_split[2]
end

local output_file = io.open(output, "w")

if (io.type(output_file) == "file") then
  output_file:write(json.stringify(atlas_json))
end
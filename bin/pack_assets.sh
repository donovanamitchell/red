# TODO: use asesprite alias
# Windows only for now
aseprite=/d/SteamLibraryHomeBase/steamapps/common/Aseprite/Aseprite.exe

# I think split layers may screw up with multiple sprites
$aseprite -b --split-layers *.png *.aseprite --sheet-pack --sheet ./atlas/atlas.png --data ./atlas/atlas.json --format json-array --trim --filename-format '{title}/{tag}/{frame}/{layer}'

$aseprite -b -script-param filename=./fireman.aseprite -script-param output=./atlas/atlas.json -script-param input=./atlas/atlas.json -script-param layer=Pivots -script-param json_impl=../bin/json.lua -script-param colormap=#FFFFFF,head,#000000,primary -script ../bin/aseprite_anchors.lua
# TODO: use asesprite alias
# Windows only for now
aseprite=/d/SteamLibraryHomeBase/steamapps/common/Aseprite/Aseprite.exe

$aseprite -b *.png *.aseprite --sheet-pack --sheet ./atlas/atlas.png --data ./atlas/atlas.json --format json-array --trim  --filename-format '{title}/{tag}/{frame}'

$aseprite -b -script-param filename=./fireman.aseprite -script-param output=./atlas/atlas.json -script-param input=./atlas/atlas.json -script-param layer=Pivots -script-param colormap=#FFFFFF,head,#000000,primary -script C:/Users/donov/AppData/Roaming/Aseprite/scripts/pivot_export.lua
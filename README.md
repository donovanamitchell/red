# Crystal on Windows

## Windows Subsystem for Linux
Yeah just google it bruh

sudo apt install libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev


## Crystal
Install it just like you would on ubuntu (or whatever WSL distro)
https://crystal-lang.org/install/on_ubuntu/

https://github.com/oprypin/crsfml

## SFML Dependencies
```bash
sudo apt-get install cmake libx11-dev \
     xorg-dev freeglut3-dev libudev-dev \
     libopenal-dev libvorbis-dev libflac-dev \
     libogg-dev libfreetype6-dev libxrandr-dev \
     libvorbisenc2 libvorbisfile3
```
## SFML
https://pryp.in/blog/12/build-sfml-and-csfml-on-linux.html
```bash
git clone https://github.com/SFML/SFML
git checkout 2.5.1 # or latest version
cd ~/SFML
cmake .
# if `cmake .` fails there's a good chance you're missing a library and it tells you that.
make
sudo make install
```

/mnt/c/Programming/crystal/at_the_gate

## CrSFML
```bash
git clone https://github.com/oprypin/crsfml
cd ./crsfml
git checkout v2.5.0 # or other release if you're feeling lucky
sfml=/mnt/e/Programming/SFML/ # or you know, wherever /home/dondo/SFML/
cd ./voidcrsfml
cmake -DSFML_DIR="$sfml" -DSFML_ROOT="$sfml" -DSFML_INCLUDE_DIR="$sfml/include" -DCMAKE_MODULE_PATH="$sfml/cmake/Modules" .
make
```

```bash
ln -s /mnt/e/Programming/crsfml ./lib/crsfml
```

Add to bash.rc?
```bash
export LIBRARY_PATH=/home/dondo/crsfml/voidcsfml
export LD_LIBRARY_PATH="$LIBRARY_PATH"
```

``` bash
cd $LD_LIBRARY_PATH
sudo ldconfig
```

https://github.com/crystal-lang/crystal/wiki/Porting-to-Windows
https://www.reddit.com/r/Windows10/comments/4ea4w4/fyi_you_can_run_gui_linux_apps_from_bash/



## Xming (or other x server)
https://sourceforge.net/projects/xming/
1. Install Xming
2. Run xming
3. Launch program with environment variable DISPLAY=:0 eg: `DISPLAY=:0 ./executable`


# at_the_gate

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

TODO list

#write up for texture packer
gamefroot-texture-packer

mock up basic board
figure out how to scale text differently from graphics

```bash
/e/SteamLibrary/steamapps/common/Aseprite/Aseprite.exe -b *.png *.aseprite --sheet-pack --sheet ./atlas/atlas.png --data ./atlas/atlas.json --format json-array --filename-format '{title}/{tag}/{frame}'

# /e/SteamLibrary/steamapps/common/Aseprite/Aseprite.exe -b ./fireman.aseprite --sheet ./fireman/sprites.png --data ./fireman/fireman.json --format json-array --list-tags

/e/SteamLibrary/steamapps/common/Aseprite/Aseprite.exe -b ./fireman.aseprite *.png --sheet-pack --sheet ./atlas/atlas.png --data ./atlas/atlas.json --format json-array --list-tags
```

## Contributing

1. Fork it (<https://github.com/your-github-user/at_the_gate/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Donovan Mitchell](https://github.com/your-github-user) - creator and maintainer

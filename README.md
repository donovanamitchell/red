# red

TODO: Write a description here

### Installation

TODO: Write installation instructions here

### Development
# Crystal on Windows

## Windows Subsystem for Linux
Yeah just google it bruh

`sudo apt install libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev`


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

/mnt/c/Programming/crystal/red

## CrSFML

TODO: I hear there are better Windows instructions with crsfml 2.5.1

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
export aseprite=/path/to/Aseprite.exe
export LIBRARY_PATH=/path/to/crsfml/voidcsfml
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

### TODO list
- Update to CRSFML v2.5.1
- Read this to make sure I didn't bork anything on my own https://pryp.in/blog/28/running-crystal-natively-on-windows-building-videogame-examples.html
- Writeup for texture packer

```bash
 aseprite -b *.png *.aseprite --sheet-pack --sheet ./atlas/atlas.png --data ./atlas/atlas.json --format json-array --trim  --filename-format '{title}/{tag}/{frame}'
```

## Contributing

1. Fork it (<https://github.com/your-github-user/red/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

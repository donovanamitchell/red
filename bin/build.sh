# build.sh
crystal build ./src/red.cr -o ./tmp/red

# perhaps add this to the asset pack instead
cp -r ./assets ./tmp/assets
# Add to rc
# TODO: move into documentation
eval $(ssh-agent)
export LIBRARY_PATH=/path/to/crsfml/voidcsfml
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=0
export PULSE_SERVER=tcp:$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)

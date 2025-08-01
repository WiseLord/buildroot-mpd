# buildroot-mpd

External buildroot subtree to generate minimal system able to play music using
MPD and control the player over UART.

## Initial build tree configuration 

```
git submodule update --init
```

## Configure and build image

```
./setup.sh <board>

make -C buildroot -j16
```

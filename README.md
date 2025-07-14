# Build and install Emacs from source
1. Fetch the source code from the release mirrors.
2. Install dependences: `sudo apt install -y build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk-4-dev libncurses-dev libgnutls28-dev libxaw7-dev`
4. `mkdir build && cd build`
5. `../configure`
6. `sudo make -jX` # use -jX if compiling with X cores
7. `sudo make -jX install` # use -jX if compiling with X cores
8. `make clean`

# Install dependencies used by .emacs
`sudo apt install -y clangd clang-format clang`

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
# If c/c++ standard headers do not auto-complete
In that case I have found two ways that seem to resolve the issue.

The first one is to create `.config/clagnd/config.yaml` and manually put the include paths there.
To get the paths run `g++ -v -x c++ -E /dev/null` and grab every path after `#include <...> search starts here:`.
Here is an example file: 

```
CompileFlags:
    Add: [
	-isystem,
	/usr/include/c++/13,
	-isystem,
	/usr/include/x86_64-linux-gnu/c++/13,
	-isystem,
	/usr/include/c++/13/backward,
	-isystem,
	/usr/lib/gcc/x86_64-linux-gnu/13/include,
	-isystem,
	/usr/local/include,
	-isystem,
	/usr/include/x86_64-linux-gnu,
	-isystem,
	/usr/include,
]
```

The second way was to check which gcc versions are installed under `/usr/lib/gcc/x86_64-linux-gnu/`. In my case I had both 13 and 14.
I am ot sure why but I had `libstdc++-13-dev` installed but not `libstdc++-14-dev`. Once I installed it, auto-complete worked as expected. 

# Build and install Emacs from source
1. Fetch the source code from the release mirrors.
2. Install dependences: `sudo apt install -y build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk-4-dev libncurses-dev libgnutls28-dev libxaw7-dev`
4. `mkdir build && cd build`
5. `../configure`
6. `sudo make -jX` # use -jX if compiling with X cores
7. `sudo make -jX install` # use -jX if compiling with X cores
8. `make clean`

# Install dependencies used by .emacs
`sudo apt install -y clang-format clang cmake`

It is better to download the latest `clangd` to benefit from any possible performance improvements:
`https://github.com/clangd/clangd`

Download the latest release and put it in yout system PATH.

# Install and configure `emacs-lsp-booster`
Install `rust` and then install `emacs-lsp-booster` by running the following command: `cargo install emacs-lsp-booster`

This will install the binary and add it to your system PATH.

Add the following configuration to the .emacs:

```lisp
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
```

Create `./emacs.d/early-init.el` and paste the following to enable plists for deserialization:
```
(setenv "LSP_USE_PLISTS" "true")
```
More information can be found here: `https://github.com/blahgeek/emacs-lsp-booster`


# If C/C++ standard headers do not auto-complete
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

The second way is to check which gcc versions are installed under `/usr/lib/gcc/x86_64-linux-gnu/`. In my case I had both 13 and 14.
I am ot sure why but I had `libstdc++-13-dev` installed but not `libstdc++-14-dev`. Once I installed it, auto-complete worked as expected. 

# compile_commands.json
To create the file run cmake with the following flag: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`

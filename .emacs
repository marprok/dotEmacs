(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")
	     t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package ivy
  :ensure t)

(ivy-mode 1) ;; Turn on ivy by default
(setq ivy-use-virtual-buffers t)  ;; no idea, but recommended by project maintainer
(setq enable-recursive-minibuffers t) ;; no idea, but recommended by project maintainer
(setq ivy-count-format "(%d/%d) ")  ;; changes the format of the number of results

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))

;; Golden Ratio
(use-package golden-ratio
  :ensure t
  :config
  (golden-ratio-mode))

;; Auto-Complete
(use-package auto-complete
  :ensure t)
(ac-config-default)
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'rust-mode)

(use-package magit
  :ensure t)

;; Move lines up/down
(use-package move-text
  :ensure t)
(move-text-default-bindings)

;; clang-format on save
(use-package clang-format+
  :ensure t)
(add-hook 'c-mode-common-hook #'clang-format+-mode)

;; Cyberpunk theme
(use-package cyberpunk-theme
  :ensure t)
(load-theme `cyberpunk t)

;; Rust mode
(use-package rust-mode
  :ensure t)
(require 'rust-mode)
(add-hook 'rust-mode-hook
		  (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages '(cyberpunk-theme golden-ratio counsel ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Generic UI customization
;; Disable the backup files.
(setq make-backup-files nil)

(setq frame-title-format "emacs")

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(set-default 'cursor-type 'hbar)

(column-number-mode)

(show-paren-mode)

(global-hl-line-mode)

(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "red")

(electric-pair-mode 1)

;; remove *GNU Emacs* buffer
(setq inhibit-splash-screen t)

;; Make a non-standard key binding.  We can put this in
;; c-mode-base-map because c-mode-map, c++-mode-map, and so on,
;; inherit from it.
(defun my-c-initialization-hook ()
  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-c-initialization-hook)

;; offset customizations not in my-c-style
;; This will take precedence over any setting of the syntactic symbol
;; made by a style.
(setq c-offsets-alist '((member-init-intro . ++)))

;; Create my personal style.
;; C++ indentation style, based on the one from Handmade Hero :)
(defconst custom-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    ;; Do not add auto-newlines before/after the following braces
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    ;; Do not add auto-newlines before/after the following colons
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    ;; remove whitespaces
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    ;; offsets
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  4)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)
				    (member-init-intro . 4)
				    (brace-list-entry . 0)))
    (c-echo-syntactic-information-p . t))
  "C++ Style")
(c-add-style "PERSONAL" custom-c-style)

;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  ;; set my personal style for the current buffer
  (c-set-style "PERSONAL")
  ;; other customizations
  (setq tab-width 4
	c-basic-offset 4
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; desable auto-newline
  (c-toggle-auto-newline -1))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq-default python-basic-offset 4
	      tab-width 4
	      indent-tabs-mode t)
;; disable bell and add ui indicator
;;(setq visible-bell 1)
;; completely turn off alarms
(setq ring-bell-function 'ignore)

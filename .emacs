(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
	     t)

(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/")
	     t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


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

;; Powerline
(use-package powerline
  :ensure t)

(require 'powerline)
(powerline-center-theme)

;; Auto-Complete
(use-package auto-complete
  :ensure t)
(ac-config-default)
(global-auto-complete-mode t)

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

;; Cyberpunk theme
(use-package cyberpunk-theme
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" default)))
 '(fci-rule-color "#383838"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Disable the backup files.
(setq make-backup-files nil)

(setq frame-title-format "emacs")

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(set-default 'cursor-type 'hbar)

;; Basic file manager autocomplete
;;(ido-mode)

(column-number-mode)

(show-paren-mode)

(global-hl-line-mode)

;;(global-linum-mode t)
;; curly braces identation
(setq-default c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode t
	      c-default-style "linux")
;;(setq c-default-style "linux")
;; remove *GNU Emacs* buffer
(setq inhibit-splash-screen t)

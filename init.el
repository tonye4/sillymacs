;; gets rid of the ugly startup
(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disables visible scrollbar
(tool-bar-mode -1) ; Disables toolbar
(tooltip-mode -1) ; Disables tool tip
(set-fringe-mode 10) ; Gives breathing room???

(menu-bar-mode -1) ; Disables the menu bar

;; Set up the visible bell
(setq visible-bell t) 

(set-face-attribute 'default nil :font "Fira Code Retina" :height 115) 

;; Initializes packages sources
(require 'package) ;; brings all package managing functions

(setq package-archives '(("melpa" . "https://melpa.org/packages/") ; Melpa is library ofcommunity package
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents(package-refresh-contents)) ; Just in case some package are not on a pc which loads this config, keep refreshing 

;; initialize use-package on non-linux platforms
(unless (package-installed-p 'use-package)(package-install 'use-package)) ; -p at the end of a function is a true or false

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes like shell mode
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode) ; shows a log of key and command presses

;; Use ivy for completions
(use-package ivy
  :diminish ; Diminish keeps ivy out of mode line, do this for some packages to keep the mode-line less busy
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-next-line) 
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . iv-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  
	 :config 
	 (ivy-mode 1)) ;; Enables ivy mode for quick M-x funciton searching

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)  ; control+alt+j switches buffer

;; Minimalist mode line and doom themes (doom mode-line)
(use-package all-the-icons)

(use-package doom-themes
  :init (load-theme 'doom-nord t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Makes parenthesis easier to see
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ;; Rainbow delim is turned on for programming-mode

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Allows you to define keys easily
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state) ; Ctrl-g enters normal mode
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join) ; Ctrl-h keeps you from having to reach for the backspace

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Hydra lets you 
(use-package hydra) ;; To paste btw do M-x clip-board-yank

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t)) ; lets you quickly scale in and out with j and k with f finishing the funciton.

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(setq org-agenda-files '("~/Notes/orgmode-files"))

(use-package org-bullets
  :ensure t
  :init (org-bullets-mode 1))

;; Syntax checking
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))

(setq custom-file "~/.emacs.d/custom.el") ; is a way to get rid of the custom file clutter
(load custom-file) 


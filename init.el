; -- UI
; disable UI elements
(setq inhibit-startup-message t
      initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 2) ; side padding
(menu-bar-mode -1)
(column-number-mode)

; font
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 140)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

; line numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(dolist (mode '(org-mode-hook ; disable line numbers in some buffer types
		vterm-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
; UI --

; editor behavior
(setq auto-save-default nil)
(setq-default indent-tabs-mode nil)
(setq ring-bell-function 'ignore)
(electric-pair-mode 1)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; https://endlessparentheses.com/ansi-colors-in-the-compilation-buffer-output.html
(require 'ansi-color)
(defun colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(add-hook 'compilation-filter-hook
          #'colorize-compilation)


; packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


; color themes
(use-package doom-themes)
(use-package gruber-darker-theme
  :config (load-theme 'gruber-darker t))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-insert-state-cursor t)
  :config
  (evil-mode 1)
  ; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

; more evil keybinds
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package yasnippet)
(use-package yasnippet-snippets)
(yas-global-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

; pretty describe
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command))
  :commands (helpful-callable helpful-variable helpful-command helpful-key))

(use-package tree-sitter-langs)
(use-package tree-sitter
    :diminish
    :after tree-sitter-langs
    :config
    (global-tree-sitter-mode)
    (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-timer-delay 0.01))

; completion system
(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous))
  :init (vertico-mode))
(use-package savehist
  :init (savehist-mode))

; search and navigation commands
(use-package consult
  :bind (("C-s" . consult-line)
         ("M-b" . consult-buffer)
         ("C-c C-r" . consult-ripgrep)))

; completion style
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

; -- lang support
(use-package markdown-mode)

(use-package rust-mode)

(use-package haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(orderless consult vertico yasnippet-snippets which-key vterm use-package tree-sitter-langs rust-mode markdown-mode magit ivy-rich helpful haskell-mode gruber-darker-theme evil-collection doom-themes diminish dashboard counsel company-box)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

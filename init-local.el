;;; init-local --- Personal local setup

;;; Commentary:

;;; Code:

;; Load extra packages
(prelude-require-packages '(monokai-theme
                            ace-window
                            popwin
                            highlight-indentation
                            linum-off
                            neotree
                            google-translate
                            wakatime-mode))


;; Set default theme
(load-theme 'monokai t)


;; scroll one line at a time (less "jumpy" than defaults)
;; http://stackoverflow.com/a/27102429
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; one line at a time
(setq-default smooth-scroll-margin 0)
(setq scroll-step 1
      scroll-margin 1
      scroll-conservatively 100000)


;; Customize more compact mode line
(require 'smart-mode-line)
(setq sml/shorten-directory t
      sml/shorten-modes t
      sml/name-width 25
      sml/mode-width 'full)
(require 'rich-minority)
(setq rm-blacklist '(" company"
                     " Fly"
                     " guru"
                     " Helm"
                     " Pre"
                     " waka"
                     " ws"))


;; Check if the system is my MacBook Pro
(defun computer-is-violin ()
  "Return true if the system we are running on is my MacBook Pro."
  (interactive)
  (string-equal
   (if (string-match "^\\([a-zA-Z0-9_-]+\\)\\." system-name)
       (match-string 1 system-name)
     system-name)
   "Violin"))


;; Set default font, initial/default frame size
(if (computer-is-violin)
    (progn
      ;; Use smaller font on laptop
      (add-to-list 'default-frame-alist '(font . "PragmataPro-14"))
      (setq-default line-spacing 4)
      ;; Near maximize frame size on laptop
      ;; http://emacs.stackexchange.com/a/10825
      (let ((px (display-pixel-width))
            (py (display-pixel-height))
            (fx (frame-char-width))
            (fy (frame-char-height))
            tx ty)
        (setq tx (- (/ px fx) 6))
        (setq ty (- (/ py fy) 4))
        (add-to-list 'default-frame-alist (cons 'width tx))
        (add-to-list 'default-frame-alist (cons 'height ty))
        (setq initial-frame-alist '((top . 2) (left . 2)))))
  (add-to-list 'default-frame-alist '(font . "Menlo-15"))
  (add-to-list 'default-frame-alist '(width . 120))
  (add-to-list 'default-frame-alist '(height . 60))
  (setq initial-frame-alist '((width . 187) (height . 67))))


;; Map mouse right click to spell check correction
;; http://stackoverflow.com/a/10997845
(require 'flyspell)
(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))


;; Display “lambda” as “λ”
(global-prettify-symbols-mode 1)


;; Turn on line number globally
(require 'linum-off)
(global-linum-mode 1)


;; Load highlight-indentation minor mode
(require 'highlight-indentation)
(dolist (hook '(emacs-lisp-mode-hook js2-mode-hook))
  (add-hook hook 'highlight-indentation-current-column-mode))


;; Default tab width
(setq-default tab-width 4)


;; Assign [F8] to toggle neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme 'nerd)
(setq neo-smart-open t)
(custom-set-faces (set-face-attribute 'neo-button-face      nil :height 120)
                  (set-face-attribute 'neo-file-link-face   nil :height 120)
                  (set-face-attribute 'neo-dir-link-face    nil :height 120)
                  (set-face-attribute 'neo-header-face      nil :height 120)
                  (set-face-attribute 'neo-expand-btn-face  nil :height 120))
(require 'projectile)
(setq projectile-switch-project-action 'neotree-projectile-action)


;; Turn on wakatime time log
(require 'wakatime-mode)
(global-wakatime-mode t)


;; EShell <TAB> file/directory completion case insensitive
(require 'em-cmpl)
(setq eshell-cmpl-ignore-case t)


;; Backup hard linked file by copying it
;; Default behavior is backup by renaming
;; http://emacs.stackexchange.com/a/4240
(setq backup-by-copying-when-linked t)


;; Disable current line highlight in eshell and ansi-term
;; http://emacs.stackexchange.com/a/9748
(add-hook 'eshell-mode-hook
          (lambda () (setq-local global-hl-line-mode nil)))
(add-hook 'term-mode-hook
          (lambda () (setq-local global-hl-line-mode nil)))


;; Turn off scroll bar
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))


;; Turn on more ace-window triggers
;; https://github.com/abo-abo/ace-window
;; x - delete
;; b - split horizontally
;; v - split vertically
;; o - maximize current window
(require 'ace-window)
(setq aw-dispatch-always t)


;; Use popup window manager
(require 'popwin)
(popwin-mode 1)
(setq popwin:special-display-config
      '(("*Help*" :stick t)
        ("helm" :regexp t)
        ;; Magit/vc
        ("*magit-commit*" :noselect t :height 40 :stick t)
        ("*magit-diff*" :noselect t :height 40)
        ("*magit-edit-log*" :noselect t :height 15)
        "*vc-diff*"
        "*vc-change-log*"
        ;; M-x compile
        (compilation-mode :noselect t)
        ;; Debug
        "*Warnings*"
        "*Backtrace*"
        "*Messages*"
        "*Compile-Log*"
        "*Shell Command Output*"
        ;; Terminal
        ;; ("\\*ansi-term\\*.*" :regexp t :height 30)
        ;; ("\\*terminal.*\\*" :regexp t :height 30)
        ;; ("*shell*" :height 30)
        ;; (term-mode :height 30 :stick t)
        ;; slime
        "*slime-apropos*"
        "*slime-macroexpansion*"
        "*slime-description*"
        "*slime-xref*"
        ("*slime-compilation*" :noselect t)
        (sldb-mode :stick t)
        slime-repl-mode
        slime-connection-list-mode
        ;; cider
        "*cider-error*"
        "*cider-macroexpansion*"
        ("*cider-doc*" :stick t)
        ("*cider-result*" :stick t)
        ("*cider-src*" :stick t)
        ;; undo-tree
        (" *undo-tree*" :width 0.2 :position right)
        ;; M-x dired-jump-other-window
        (dired-mode :position top)))


;; Xah Lee's implementation of search-current-world
(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
`word' here is A to Z, a to z, and hyphen - and underline _, independent
of syntax table.
URL `http://ergoemacs.org/emacs/modernization_isearch.html'
Version 2015-04-09"
  (interactive)
  (let ( ξp1 ξp2 )
    (if (use-region-p)
        (progn
          (setq ξp1 (region-beginning))
          (setq ξp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq ξp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq ξp2 (point))))
    (setq mark-active nil)
    (when (< ξp1 (point))
      (goto-char ξp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties ξp1 ξp2))))


;; Bind `C-*' and `C-#' to search current word, similar to VIM
(global-set-key (kbd "C-*") 'xah-search-current-word)
(progn
  ;; Set arrow keys in isearch.
  ;; http://ergoemacs.org/emacs/emacs_isearch_by_arrow_keys.html
  ;; Left/right is backward/forward, up/down is history. Press Return to exit.
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )
  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward))


;; Map HOME and END key to be same as C-a and C-e
;; Same for Cmd-left and Cmd-right on OS X
(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'end-of-line)
(when (eq system-type 'darwin)
  (global-set-key [s-left] 'move-beginning-of-line)
  (global-set-key [s-right] 'end-of-line))


;; Page down/up move the point, not the screen.
;; In practice, this means that they can move the
;; point to the beginning or end of the buffer.
;; http://snarfed.org/emacs_page_up_page_down
(global-set-key [next]
                (lambda () (interactive)
                  (condition-case nil (scroll-up)
                    (end-of-buffer (goto-char (point-max))))))
(global-set-key [prior]
                (lambda () (interactive)
                  (condition-case nil (scroll-down)
                    (beginning-of-buffer (goto-char (point-min))))))


;; Setup google translate
(require 'google-translate)
(require 'google-translate-default-ui)
(setq google-translate-default-target-language '"zh-CN")
(global-set-key "\C-cT" 'google-translate-at-point)


;; Launch Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))


(provide 'init-local)
;;; init-local.el ends here

;;; init-local --- Personal local setup

;;; Commentary:

;;; Code:

;; Check if the system is my MacBook Pro
(defun computer-is-violin ()
  "Return true if the system we are running on is my MacBook Pro."
  (interactive)
  (string-equal
   (if (string-match "^\\([a-zA-Z0-9_-]+\\)\\." system-name)
       (match-string 1 system-name)
     system-name)
   "Violin"))


;; Xah Lee's implementation of search-current-world
(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
“word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of
syntax table.
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


;; Load extra packages
(prelude-require-packages '(monokai-theme
                            ace-window
                            smooth-scrolling
                            linum-off
                            neotree
                            wakatime-mode))


;; Set default theme
(load-theme 'monokai t)


;; Set initial and default frame size
(setq initial-frame-alist '((width . 150) (height . 70)))
(setq default-frame-alist '((width . 120) (height . 60)))


;; Turn on smooth scrolling
(require 'smooth-scrolling)


;; Set default font
;; Use smaller font and shorter mode line  on laptop
(require 'smart-mode-line)
(if (computer-is-violin)
    (progn
      (add-to-list 'default-frame-alist '(font . "PragmataPro-13"))
      (setq sml/shorten-directory t)
      (setq sml/shorten-modes t)
      (setq sml/name-width 25)
      (setq sml/mode-width 'full)
      )
  (add-to-list 'default-frame-alist '(font . "Menlo-15")))


;; Display “lambda” as “λ”
(global-prettify-symbols-mode 1)


;; Turn on line number globally
(require 'linum-off)
(global-linum-mode 1)


;; Default tab width
(setq-default tab-width 4)


;; Assign [F8] to toggle neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq projectile-switch-project-action 'neotree-projectile-action)


;; Turn on wakatime time log
(require 'wakatime-mode)
(global-wakatime-mode t)


;; EShell <TAB> file/directory completion case insensitive
(require 'eshell)
(setq eshell-cmpl-ignore-case t)


;; Save desktop mode
(desktop-save-mode 1)
(setq-default history-length 1000)
(savehist-mode t)


;; Backup hard linked file by copying it
;; Default behavior is backup by renaming
;; http://emacs.stackexchange.com/a/4240
(setq backup-by-copying-when-linked t)


;; Disable current line highlight in eshell and ansi-term
;; http://emacs.stackexchange.com/a/9748
(add-hook 'eshell-mode-hook (lambda ()
                              (setq-local global-hl-line-mode
                                          nil)))
(add-hook 'term-mode-hook (lambda ()
                            (setq-local global-hl-line-mode
                                        nil)))


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


;; Bind `C-*' and `C-#' to search current word, similar to VIM
(global-set-key (kbd "C-*") 'xah-search-current-word)
(global-set-key (kbd "C-#") 'xah-search-current-word)


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


;; Launch Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))


(provide 'init-local)
;;; init-local.el ends here

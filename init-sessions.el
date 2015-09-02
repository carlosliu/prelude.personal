;;; init-sessions --- sessions setup

;;; Commentary:

;;; Code:

(require 'desktop)

;; save a list of open files in ~/.emacs.d/.emacs.desktop
(setq desktop-path (list user-emacs-directory)
      desktop-auto-save-timeout 600)
(desktop-save-mode 1)


;; Restore histories and registers after saving
(setq-default history-length 1000)
(savehist-mode t)

(provide 'init-sessions)
;;; init-sessions.el ends here

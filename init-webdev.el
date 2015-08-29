;;; init-webdev.el --- additional web development setup

;;; Commentary:

;;; Code:

(prelude-require-packages '(less-css-mode
                            skewer-mode
                            tern
                            nodejs-repl))


;; Setup tern and company-tern
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(require 'company)
(eval-after-load 'company
  '(progn
     (prelude-require-packages '(company-tern))
     (add-to-list 'company-backends 'company-tern)))


(require 'js2-mode)
;; Hook js2-mode for shell scripts running via node.js:
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
;; Setup js2-mode
(eval-after-load 'js2-mode
  '(progn
     (setq js2-missing-semi-one-line-override t)
     (setq js2-bounce-indent-p t)
     (setq js2-indent-switch-body t)
     (setq-default js2-basic-offset 2)))


;; Hook skewer-mode
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)


(require 'web-mode)
;; Use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
;; Adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook 'my-web-mode-hook)


(require 'flycheck)
;; Use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; Disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))
;; Disable json-jsonlint checking for json files
;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(json-jsonlint)))


(provide 'init-webdev)
;;; init-webdev.el ends here

;;; init-webdev.el --- additional web development setup

;;; Commentary:

;;; Code:

(prelude-require-packages '(tern skewer-mode nodejs-repl))
;; Setup tern and company-tern
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load "company"
  '(progn
     (prelude-require-packages '(company-tern))
     (add-to-list 'company-backends 'company-tern)))
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)

(provide 'init-webdev)
;;; init-webdev.el ends here

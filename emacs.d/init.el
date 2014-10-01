(require 'package)
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

; relative line numbers
(require 'linum-relative)
(global-linum-mode t)

; set up elpy
(setq python-check-command "/usr/local/bin/pyflakes")
(elpy-enable)
(elpy-use-ipython "/usr/local/bin/ipython")

(require 'color-theme)
(color-theme-initialize)
(load-theme 'spacegray t)

(require 'ido)
(ido-mode t)

; org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq fiplr-ignored-globs '((directories (".git" ".svn"))
                            (files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc"))))
(global-set-key (kbd "C-x f") 'fiplr-find-file)


;;; company-go.el --- company-mode backend for Go (using gocode)
;; Version: 20140505.1312

;; Copyright (C) 2012

;; Author: nsf <no.smile.face@gmail.com>
;; Keywords: languages
;; Package-Requires: ((company "0.8.0"))

;; No license, this code is under public domain, do whatever you want.

;;; Code:

(eval-when-compile
  (require 'cl)
  (require 'company)
  (require 'go-mode))

;; Close gocode daemon at exit unless it was already running
(eval-after-load "go-mode"
  '(progn
     (let* ((user (or (getenv "USER") "all"))
            (sock (format (concat temporary-file-directory "gocode-daemon.%s") user)))
       (unless (file-exists-p sock)
         (add-hook 'kill-emacs-hook #'(lambda ()
                                        (ignore-errors
                                          (call-process "gocode" nil nil nil "close"))))))))

(defgroup company-go nil
  "Completion back-end for Go."
  :group 'company)

(defcustom company-go-show-annotation nil
  "Show an annotation inline with the candidate."
  :group 'company-go
  :type 'boolean)

(defcustom company-go-begin-after-member-access t
  "When non-nil, automatic completion will start whenever the current
symbol is preceded by a \".\", ignoring `company-minimum-prefix-length'."
  :group 'company-go
  :type 'boolean)

(defun company-go--invoke-autocomplete ()
  (let ((temp-buffer (generate-new-buffer "*gocode*")))
    (prog2
	(call-process-region (point-min)
			     (point-max)
			     "gocode"
			     nil
			     temp-buffer
			     nil
			     "-f=csv"
			     "autocomplete"
			     (or (buffer-file-name) "")
			     (concat "c" (int-to-string (- (point) 1))))
	(with-current-buffer temp-buffer (buffer-string))
      (kill-buffer temp-buffer))))

(defun company-go--format-meta (candidate)
  (let ((class (nth 0 candidate))
	(name (nth 1 candidate))
	(type (nth 2 candidate)))
    (setq type (if (string-prefix-p "func" type)
		   (substring type 4 nil)
		 (concat " " type)))
    (concat class " " name type)))

(defun company-go--get-candidates (strings)
  (mapcar (lambda (str)
	    (let ((candidate (split-string str ",,")))
	      (propertize (nth 1 candidate) 'meta (company-go--format-meta candidate)))) strings))

(defun company-go--candidates ()
  (company-go--get-candidates (split-string (company-go--invoke-autocomplete) "\n" t)))

(defun company-go--location (arg)
  (when (require 'go-mode nil t)
    (company-go--location-1 arg)))

(defun company-go--location-1 (arg)
  (let* ((temp (make-temp-file
                (directory-file-name
                 (expand-file-name "company-go--location"))))
         (buffer (current-buffer))
         (prefix-len (length company-prefix))
         (point (point))
         (temp-buffer (find-file-noselect temp)))
    (unwind-protect
        (progn
          (with-current-buffer temp-buffer
            (insert-buffer-substring buffer)
            (goto-char point)
            (insert (substring arg prefix-len))
            (goto-char point)
            (company-go--godef-jump point)))
      (ignore-errors
         (with-current-buffer temp-buffer
           (set-buffer-modified-p nil))
        (kill-buffer temp-buffer)
        (delete-file temp)))))

(defun company-go--prefix ()
  "Returns the symbol to complete. Also, if point is on a dot,
triggers a completion immediately."
  (if company-go-begin-after-member-access
      (company-grab-symbol-cons "\\." 1)
    (company-grab-symbol)))

(defun company-go--godef-jump (point)
  (condition-case nil
      (let ((file (car (godef--call point))))
        (cond
         ((string= "-" file)
          (message "company-go: expression is not defined anywhere") nil)
         ((string= "company-go: no identifier found" file)
          (message "%s" file) nil)
         ((go--string-prefix-p "godef: no declaration found for " file)
          (message "%s" file) nil)
         ((go--string-prefix-p "error finding import path for " file)
          (message "%s" file) nil)
         (t (if (not (string-match "\\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" file))
                (cons (find-file-noselect file) 0)
              (let ((filename (match-string 1 file))
                    (line (string-to-number (match-string 2 file)))
                    (column (string-to-number (match-string 3 file))))
                (with-current-buffer (find-file-noselect filename)
                  (go--goto-line line)
                  (beginning-of-line)
                  (forward-char (1- column))
                  (cons (current-buffer) (point))))))))
    (file-error (message "company-go: Could not run godef binary") nil)))

;;;###autoload
(defun company-go (command &optional arg &rest ignored)
  (case command
    (prefix (and (derived-mode-p 'go-mode)
                 (not (company-in-string-or-comment))
                 (or (company-go--prefix) 'stop)))
    (candidates (company-go--candidates))
    (meta (get-text-property 0 'meta arg))
    (annotation
     (when company-go-show-annotation
       (get-text-property 0 'meta arg)))
    (location (company-go--location arg))
    (sorted t)))

(provide 'company-go)
;;; company-go.el ends here

;;;					-*-mode:lisp; coding:utf-8-unix;-*-

;; packages
;; ########

(package-initialize)
(require  'package)
(add-to-list 'package-archives
	     '("ELPA" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; environment variables and similar
;; #################################

(if (string= system-type "darwin")
    (progn
      (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin" ":/usr/local/MacGPG2/bin"))
      (setq exec-path (cons "/usr/local/MacGPG2/bin" (cons "/usr/local/bin" exec-path)))))

;; path for custom lisp files
(setq load-path
      (cons (expand-file-name "~/.emacs.d/lisp") load-path))

;; ssh related
;; ###########

(if (string= system-type "darwin")
    (setenv "SSH_AUTH_SOCK" "/Users/eric/.gnupg/S.gpg-agent.ssh"))

;; misc modes
;; ##########
(require 'jka-compr)
(auto-compression-mode)
(require 'uniquify)

;; version control
;; ###############
(require 'vc)
(require 'vc-hooks)

(setq minibuffer-confirm-incomplete t)
(setq user-full-name "Eric Knauel")

;; useful functions
;; ################

(defun cut-to-register (register start end &optional noise)
  (interactive "cCut to register: \nr\nP")
  (if (string-match "c" (string register))
      (progn
	(message "Copying selection also to clipboard")
	(copy-primary-selection)))
  (copy-to-register register start end t))

(define-key global-map "\C-xc" 'cut-to-register)

(defun join-lines ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))
    
(global-set-key (kbd "C-^") 'join-lines)

(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(global-set-key (kbd "M-Q") 'unfill-paragraph)

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;; global key definitions
;; ######################

(global-set-key "\M-#" 'dabbrev-expand)
(global-set-key [(control c) + c c] 'comment-region)
(global-set-key [(control c) + c u] 'uncomment-region)
(global-set-key [(control c) + r] 'revert-buffer)


;; cycle buffer rocks
;; ##################

(autoload 'cyclebuffer-forward "cyclebuffer" "cycle forward" t)
(autoload 'cyclebuffer-backward "cyclebuffer" "cycle backward" t)
(global-set-key "\M-N" 'cyclebuffer-forward)
(global-set-key "\M-P" 'cyclebuffer-backward)

;; customization stuff
;; ###################

(let ((file-name (expand-file-name "~/dot-emacs.git/custom.el")))
  (if (file-exists-p file-name)
      (progn
	(setq custom-file file-name)
	(load custom-file))
    (message "WARNING: custom.el not found!")))

;; manual settings
;; ###############

(custom-set-variables
  '(dired-hide-details-hide-symlink-targets t))

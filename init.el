;; -*- coding: utf-8; lexical-binding: t; -*-

(let* ((minver "24.4"))
  (when (version< emacs-version minver)
    (error "Emacs v%s or higher is required." minver)))

(defvar best-gc-cons-threshold
  4000000
  "Best default gc threshold value.  Should NOT be too big!")

;; don't GC during startup to save time
(setq gc-cons-threshold most-positive-fixnum)

(setq emacs-load-start-time (current-time))

;; {{ emergency security fix
;; https://bugs.debian.org/766397
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))
;; }}
;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *emacs24* (and (not (featurep 'xemacs)) (or (>= emacs-major-version 24))) )
(setq *emacs25* (and (not (featurep 'xemacs)) (or (>= emacs-major-version 25))) )
(setq *no-memory* (cond
                   (*is-a-mac*
                    (< (string-to-number (nth 1 (split-string (shell-command-to-string "sysctl hw.physmem")))) 4000000000))
                   (*linux* nil)
                   (t nil)))

;; @see https://www.reddit.com/r/emacs/comments/55ork0/is_emacs_251_noticeably_slower_than_245_on_windows/
;; Emacs 25 does gc too frequently
(when *emacs25*
  ;; (setq garbage-collection-messages t) ; for debug
  (setq best-gc-cons-threshold (* 64 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 5 t #'garbage-collect))

(defmacro local-require (pkg)
  `(unless (featurep ,pkg)
     (cond
      ((eq ,pkg 'bookmark+)
       (load (file-truename (format "~/.emacs.d/site-lisp/bookmark-plus/%s" ,pkg)) t t))
      ((eq ,pkg 'go-mode-load)
       (load (file-truename (format "~/.emacs.d/site-lisp/go-mode/%s" ,pkg)) t t))
      (t
       (load (file-truename (format "~/.emacs.d/site-lisp/%s/%s" ,pkg ,pkg)) t t)))))

(defmacro require-init (pkg)
  `(load (file-truename (format "~/.emacs.d/lisp/%s" ,pkg)) t t))

;; *Message* buffer should be writable in 24.4+
(defadvice switch-to-buffer (after switch-to-buffer-after-hack activate)
  (if (string= "*Messages*" (buffer-name))
      (read-only-mode -1)))

;; @see https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; Normally file-name-handler-alist is set to
;; (("\\`/[^/]*\\'" . tramp-completion-file-name-handler)
;; ("\\`/[^/|:][^/|]*:" . tramp-file-name-handler)
;; ("\\`/:" . file-name-non-special))
;; Which means on every .el and .elc file loaded during start up, it has to runs those regexps against the filename.
(let* ((file-name-handler-alist nil))
  ;; `package-initialize' takes 35% of startup time
  ;; need check https://github.com/hlissner/doom-emacs/wiki/FAQ#how-is-dooms-startup-so-fast for solution
  (require-init 'init-autoload)
  (require-init 'init-modeline)
  (require-init 'init-utils)
  (require-init 'init-elpa)
  (require-init 'init-exec-path) ;; Set up $PATH
  ;; Any file use flyspell should be initialized after init-spelling.el
  (require-init 'init-spelling)
  (require-init 'init-gui-frames)
  (require-init 'init-uniquify)
  (require-init 'init-ibuffer)
  (require-init 'init-ivy)
  (require-init 'init-hippie-expand)
  (require-init 'init-windows)
  (require-init 'init-markdown)
  (require-init 'init-erlang)
  (require-init 'init-javascript)
  (require-init 'init-org)
  (require-init 'init-css)
  (require-init 'init-python)
  (require-init 'init-haskell)
  (require-init 'init-ruby-mode)
  (require-init 'init-lisp)
  (require-init 'init-elisp)
  (require-init 'init-yasnippet)
  ;; Use bookmark instead
  (require-init 'init-cc-mode)
  (require-init 'init-gud)
  (require-init 'init-linum-mode)
  (require-init 'init-git) ;; git-gutter should be enabled after `display-line-numbers-mode' turned on
  ;; (require-init 'init-gist)
  (require-init 'init-gtags)
  ;; init-evil dependent on init-clipboard
  (require-init 'init-clipboard)
  ;; use evil mode (vi key binding)
  (require-init 'init-evil)
  (require-init 'init-multiple-cursors)
  (require-init 'init-ctags)
  (require-init 'init-bbdb)
  (require-init 'init-gnus)
  (require-init 'init-lua-mode)
  (require-init 'init-workgroups2)
  (require-init 'init-term-mode)
  (require-init 'init-web-mode)
  (require-init 'init-company)
  (require-init 'init-chinese) ;; cannot be idle-required
  ;; need statistics of keyfreq asap
  (require-init 'init-keyfreq)
  (require-init 'init-httpd)

  ;; projectile costs 7% startup time

  ;; misc has some crucial tools I need immediately
  (require-init 'init-misc)

  (require-init 'init-emacs-w3m)
  (require-init 'init-hydra)
  (require-init 'init-shackle)
  (require-init 'init-dired)
  (require-init 'init-artbollocks-mode)
  (require-init 'init-writting)

  ;; @see https://github.com/hlissner/doom-emacs/wiki/FAQ
  ;; Adding directories under "~/.emacs.d/site-lisp/" to `load-path' slows
  ;; down all `require' statement. So we do this at the end of startup
  ;; Besides, no packages from ELPA is dependent on "~/.emacs.d/site-lisp".
  (require-init 'init-site-lisp)

  ;; my personal setup, other major-mode specific setup need it.
  ;; It's dependent on "~/.emacs.d/site-lisp/*.el"
  (if (file-exists-p "~/.custom.el") (load-file "~/.custom.el"))

  ;; @see https://www.reddit.com/r/emacs/comments/4q4ixw/how_to_forbid_emacs_to_touch_configuration_files/
  (setq custom-file (concat user-emacs-directory "custom-set-variables.el"))
  (load custom-file 'noerror))

(setq gc-cons-threshold best-gc-cons-threshold)

(when (require 'time-date nil t)
  (message "Emacs startup time: %d seconds."
           (time-to-seconds (time-since emacs-load-start-time))))

;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)


(require-init 'util-lisp)
(defun kh/add-hook (hooks funcs &optional append local)
  "More general definition of function add-hook."
  (unless (listp hooks)
    (setq hooks (list hooks)))
  (unless (listp funcs)
    (setq funcs (list funcs)))
  (dolist (hook hooks)
    (dolist (func funcs)
      (add-hook hook func append local))))
(setq scheme-program-name "guile")
(kh/add-hook '(scheme-mode-hook)
             '((lambda ()
                 (local-set-key (kbd "C-x C-e") 'kh/scheme-send-last-sexp))))


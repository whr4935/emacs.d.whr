(provide 'setup-programming)

;; GROUP: Programming -> Languages -> C

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (c-mode . "linux")
                        (c++-mode . "stroustrup")
                        (other . "gnu"))
      c-basic-offset 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Programming -> Tools -> Gdb ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq gdb-many-windows t        ; use gdb-many-windows by default
      gdb-show-main t)          ; Non-nil means display source file containing the main routine at startup



(defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
  "my gdb UI"
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))
        (win1 (split-window nil nil 'left))      ;code and output
        (win2 (split-window-below (/ (* (window-height) 2) 3)))     ;stack
        )
    (select-window win2)
    (gdb-set-window-buffer (gdb-stack-buffer-name))
    (select-window win1)
    (set-window-buffer
     win1
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (if gdb-main-file
           (gud-find-file gdb-main-file)
         ;; Put buffer list in window if we
         ;; can't find a source file.
         (list-buffers-noselect))))
    (setq gdb-source-window (selected-window))
    (let ((win3 (split-window nil (/ (* (window-height) 3) 4)))) ;io
      (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win3))
    (select-window win0)
    ))




;; (add-hook gdb-many-windows-hook (lambda ()
;;                                   (gdb-)))

;; (defvar gud-overlay
;;   (let* ((ov (make-overlay (point-min) (point-min))))
;;     (overlay-put ov 'face 'secondary-selection)
;;     ov)
;;   "Overlay variable for GUD highlighting.")

;; (defadvice gud-display-line (after my-gud-highlight activate)
;;   "Highlight current line."
;;   (let* ((ov gud-overlay)
;;          (bf (gud-find-file true-file)))
;;     (with-current-buffer bf
;;       (move-overlay ov (line-beginning-position) (line-beginning-position 2)
;;                     (current-buffer)))))

;; (defun gud-kill-buffer ()
;;   (if (derived-mode-p 'gud-mode)
;;       (delete-overlay gud-overlay)))

;; (add-hook 'kill-buffer-hook 'gud-kill-buffer)

;; ;; {{ hack buffer
;; ;; move the cursor to the end of last line if it's gud-mode
;; (defun hack-gud-mode ()
;;   (when (string= major-mode "gud-mode")
;;     (goto-char (point-max))))

;; (defadvice switch-to-buffer (after switch-to-buffer-after activate)
;;   (hack-gud-mode))

;; (defadvice select-window-by-number (after select-window-by-number-after activate)
;;   (hack-gud-mode))

;; ;; windmove-do-window-select is from windmove.el
;; (defadvice windmove-do-window-select (after windmove-do-window-select-after activate)
;;   (hack-gud-mode))
;; ;; }}

;; (defun gud-cls (&optional num)
;;   "clear gud screen"
;;   (interactive "p")
;;   (let ((old-window (selected-window)))
;;     (save-excursion
;;       (cond
;;        ((buffer-live-p (get-buffer "*gud-main*"))
;;         (select-window (get-buffer-window "*gud-main*"))
;;         (end-of-buffer)
;;         (recenter-top-bottom)
;;         (if (> num 1) (recenter-top-bottom))
;;         (select-window old-window))
;;        (t (error "GUD buffer doesn't exist!"))
;;        ))
;;     ))

;; (eval-after-load 'gud
;;                  '(progn
;;                     (gud-def gud-kill "kill" "\C-k" "Kill the debugee")
;;                     ))

;; (defun gud-kill-yes ()
;;   "gud-kill and confirm with y"
;;   (interactive)
;;   (let ((old-window (selected-window)))
;;     (save-excursion
;;       (cond
;;        ((buffer-live-p (get-buffer "*gud-main*"))
;;         (gud-kill nil)
;;         (select-window (get-buffer-window "*gud-main*"))
;;         (insert "y")
;;         (comint-send-input)
;;         (recenter-top-bottom)
;;         (select-window old-window))
;;        (t (error "GUD buffer doesn't exist!"))
;;        ))
;;     ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Programming -> Tools -> Compilation ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compilation from Emacs
(defun prelude-colorize-compilation-buffer ()
  "Colorize a compilation mode buffer."
  (interactive)
  ;; we don't want to mess with child modes such as grep-mode, ack, ag, etc
  (when (eq major-mode 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max)))))

;; setup compilation-mode used by `compile' command
(require 'compile)
(setq compilation-ask-about-save nil          ; Just save before compiling
      compilation-always-kill t               ; Just kill old compile processes before starting the new one
      compilation-scroll-output 'first-error) ; Automatically scroll to first
(global-set-key (kbd "<f7>") (lambda ()
                               (interactive)
                               (setq-local compile-command (format "make -k -f %s" project-makefile))
                               (setq-local default-directory project-build-root)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

(global-set-key (kbd "S-<f7>") (lambda ()
                                 (interactive)
                                 (setq-local compile-command (format "make clean -f %s" project-makefile))
                                 (setq-local default-directory project-build-root)
                                 (setq-local compilation-read-command nil)
                                 (call-interactively 'compile)))



(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local gdb-command (format "gdb -i=mi %s" project-bin))
                               (setq-local gdb-read-command nil)
                               (gdb gdb-command)))

;; GROUP: Programming -> Tools -> Makefile
;; takenn from prelude-c.el:48: https://github.com/bbatsov/prelude/blob/master/modules/prelude-c.el
;; (defun prelude-makefile-mode-defaults ()
;;   (whitespace-toggle-options '(tabs))
;;   (setq indent-tabs-mode t ))

;; (setq prelude-makefile-mode-hook 'prelude-makefile-mode-defaults)

;; (add-hook 'makefile-mode-hook (lambda ()
;;                                 (run-hooks 'prelude-makefile-mode-hook)))

;; GROUP: Programming -> Tools -> Ediff
(setq ediff-diff-options "-w"
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)

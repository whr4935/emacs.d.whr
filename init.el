;;
;;

;;(setq debug-on-error t)

(require 'package)
(setq package-archives '(
             ;;("myelpa" . "~/workspace/emacs/myelpa")
             ("melpa" . "http://melpa.org/packages/")
             ;;("melpa-stable" . "http://stable.melpa.org/packages/")
             ))
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/custom/")

;;(mapc 'load (directory-files "~/.emacs.d/custom" t ".*\.el"))
;; load your modules
(require 'setup-applications)
(require 'setup-communication)
(require 'setup-convenience)
(require 'setup-data)
(require 'setup-development)
(require 'setup-editing)
(require 'setup-environment)
(require 'setup-external)
(require 'setup-faces-and-ui)
(require 'setup-files)
(require 'setup-help)
(require 'setup-programming)
(require 'setup-text)
(require 'setup-local)

(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-DEL") 'kill-whole-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ibuffer                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: smartparens               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: yasnippet                 ;;
;;                                    ;;
;; GROUP: Editing -> Yasnippet        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
;; (yas-global-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: expand-region                       ;;
;;                                              ;;
;; GROUP: Convenience -> Abbreviation -> Expand ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'expand-region)
(global-set-key (kbd "M-m") 'er/expand-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: dired+                     ;;
;;                                     ;;
;; GROUP: Files -> Dired -> Dired Plus ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'dired+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: nyan-mode                    ;;
;;                                       ;;
;; GROUOP: Environment -> Frames -> Nyan ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; only turn on if a window system is available
;; this prevents error under terminal that does not support X
(case window-system
  ((x w32) (nyan-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight-symbol-mode              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'highlight-symbol)
(highlight-symbol-nav-mode)

(add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
(add-hook 'org-mode-hook (lambda () (highlight-symbol-mode)))

(setq highlight-symbol-idle-delay 0.2
      highlight-symbol-on-navigation-p t)

(global-set-key [(control shift mouse-1)]
                (lambda (event)
                  (interactive "e")
                  (goto-char (posn-point (event-start event)))
                  (highlight-symbol-at-point)))

(global-set-key (kbd "M-n") 'highlight-symbol-next)
(global-set-key (kbd "M-p") 'highlight-symbol-prev)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; discover-my-major                               ;;
;;                                                 ;;
;;  A quick major mode help with discover-my-major ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-unset-key (kbd "C-h h"))        ; original "C-h h" displays "hello world" in different languages
(define-key 'help-command (kbd "h m") 'discover-my-major)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; window-numbering                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'window-numbering)
(window-numbering-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my init lisp                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'init-gtags)
(require 'init-helm)
(require 'init-company)
;; (require 'cpputils-cmake)
(require 'init-projectile)
(require 'init-cedet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gdb                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq
;;  ;; use gdb-many-windows by default
;;  gdb-many-windows t

;;  ;; Non-nil means display source file containing the main routine at startup
;;  gdb-show-main t
;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function-args                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'function-args)
;; (fa-config-default)

;;;;;;;;;;;;
;; rebox2 ;;
;;;;;;;;;;;;
;;(setq rebox-style-loop '(24 16))
(require 'rebox2)
;; ;;(global-set-key [(meta q)] 'rebox-dwim)
;; ;;(global-set-key [(shift meta q)] 'rebox-cycle)
;; (rebox-mode t)
;; (add-hook 'after-init-hook (lambda() (rebox-mode t)))

;; setup rebox for emacs-lisp
       (add-hook 'emacs-lisp-mode-hook (lambda ()
                                         (set (make-local-variable 'rebox-style-loop) '(25 17 21))
                                         (set (make-local-variable 'rebox-min-fill-column) 40)
                                         (rebox-mode 1)))

;;    Default `rebox-style-loop' should work for most programming modes, however,
;;    you may want to set the style you prefer.
;;
;;    Here is an customization example that
;;
;;      - sets comments to use "/* ... */" style in c++-mode
;;      - adds Doxygen box style for C++

(defun my-c++-setup ()
  (setq comment-start "/* "
        comment-end " */")
  (unless (memq 46 rebox-style-loop)
    (make-local-variable 'rebox-style-loop)
    (nconc rebox-style-loop '(46))))
(add-hook 'c++-mode-hook #'my-c++-setup)

(defun my-c-setup ()
  (setq comment-start "/* "
        comment-end " */")
  (unless (memq 46 rebox-style-loop)
    (make-local-variable 'rebox-style-loop)
    (nconc rebox-style-loop '(46))))

(add-hook 'c-mode-hook #'my-c-setup)

;;;;;;;;;;;;;;;;;;;;;;;;
;; clean-aindent-mode ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'clean-aindent-mode)
;; (add-hook 'prog-mode-hook 'clean-aindent-mode)

;;;;;;;;;;;;;
;; Folding ;;
;;;;;;;;;;;;;
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(setq
 c-default-style "linux")

(global-set-key (kbd "RET") 'newline-and-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sr-speedbar                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sr-speedbar-right-side nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: dtrt-indent ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'dtrt-indent)
;; (dtrt-indent-mode 1)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ecb-options-version "2.40"))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((project-bin . "~/workspace/project/gdb_test/net/build/bin/server")
     (project-build-root . "~/workspace/project/gdb_test/net/build/")
     (project-bin . "~/workspace/project/gdb_test/net/build/bin/net")
     (project-makefile . "~/workspace/project/gdb_test/net/build/Makefile")
     (project-bin . "~/workspace/project/gdb_test/psax/build/bin/psax")
     (project-makefile . "~/workspace/project/gdb_test/psax/build/Makefile")
     (project-build-root . "~/workspace/project/gdb_test/psax/build/")
     (project-bin . "~/workspace/project/gdb_test/cstring/build/bin/cstring")
     (project-makefile . "~/workspace/project/gdb_test/cstring/build/Makefile")
     (project-build-root . "~/workspace/project/gdb_test/cstring/build/")
     (project-bin . "~/workspace/project/gdb_test/bintree/build/bin/bintree")
     (project-makefile . "~/workspace/project/gdb_test/bintree/build/Makefile")
     (project-build-root . "~/workspace/project/gdb_test/bintree/build/")
     (project-bin . "~/workspace/project/gdb_test/insert/build/bin/gdb_test")
     (project-makefile . "~/workspace/project/gdb_test/insert/build/Makefile")
     (project-build-root . "~/workspace/project/gdb_test/insert/build/")
     (project-build-root . "/home/whr/workspace/project/c_plus_plus_primer/src/build/")
     (project-bin . "/home/whr/workspace/project/c_plus_plus_primer/src/build/bin/c_plus_plus_primer")
     (project-makefile . "/home/whr/workspace/project/c_plus_plus_primer/src/build/Makefile")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

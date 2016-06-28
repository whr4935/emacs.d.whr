(provide 'init-cedet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use cedet-bzr                      ;;
;;
;; git clone http://git.code.sf.net/p/cedet/git
;; cd cedet
;; make # wait for it to complete
;; cd contrib
;; make
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file (concat user-emacs-directory "/cedet/cedet-devel-load.el"))
(load-file (concat user-emacs-directory "cedet/contrib/cedet-contrib-load.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CEDET                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)
(require 'semantic)
(require 'stickyfunc-enhance)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
;; (global-semantic-idle-summary-mode 1)
(global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)

;; if you want to enable support for gnu global
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;; (defun my-cedet-hook ()
;;   (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;;   (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
;;   (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;;   (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
;;   (message "fdsfssssssssssssssssssssssss")
;;   (local-set-key (kbd "C-c , C-j") 'semantic-ia-fast-jump)
;;   )
;; (add-hook 'c-mode-common-hook 'my-cedet-hook)

;; (defun semantic-init-func2 ()
;;   (setq qt5-base-dir "/opt/Qt5.7.0/5.7/gcc_64/include/")
;;   (semantic-add-system-include qt5-base-dir )
;;   (add-to-list 'auto-mode-alist (cons qt5-base-dir 'c++-mode))
;;   (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "QtCore/qconfig.h"))
;;   (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "QtCore/qconfig-dist.h"))
;;   (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "QtCore/qglobal.h"))
;;   )
;; (add-hook 'c-mode-common-hook 'semantic-init-func2)

(define-key semantic-mode-map (kbd "C-c , j") 'semantic-ia-fast-jump)

(semantic-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ede                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ede)
(global-ede-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; srefactor                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'srefactor)
;; (require 'srefactor-lisp)

;; ;; OPTIONAL: ADD IT ONLY IF YOU USE C/C++.
;; ;; (semantic-mode 1)
;; ;; -> this is optional for Lisp

;; (define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
;; (define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
;; (global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
;; (global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
;; (global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
;; (global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)

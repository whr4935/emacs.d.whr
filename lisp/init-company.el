(provide 'init-company)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company-c-headers                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'company-c-headers)
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/5")
;; (add-to-list 'company-backends 'company-c-headers)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; irony                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gen compilation database.
;; cmake . -DCMAKE_EXPORT_COMPILE_COMMANDS=1

(require 'irony)
(add-hook 'c++mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company-ircony-c-headers           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company-irony-c-headers)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: company              ;;
;;                               ;;
;; GROUP: Convenience -> Company ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company)

;;company-backends
;; (add-to-list 'company-backends '(company-gtags company-c-headers company-clang))

(defun init-company ()
  (global-company-mode)
  (global-set-key (kbd "C-;") 'company-complete)
  ;; (define-key c++-mode-map (kbd "C-;") 'company-complete)
  (setq company-show-numbers t
        ;; company-tooltip-limit 20
        company-minimum-prefix-length 2
        ;; company-dabbrev-downcase nil
        ;; company-dabbrev-ignore-case nil
        company-idle-delay 0.3
        ;; company-require-match nil
        )

  (add-to-list 'company-backends '(company-irony-c-headers company-irony))
  (setq company-backends (delete 'company-dabbrev company-backends))
  (setq company-backends (delete 'company-gtags company-backends))
  (setq company-backends (delete 'company-clang company-backends))
  (setq company-backends (delete 'company-semantic company-backends))

  )
(add-hook 'after-init-hook 'init-company)

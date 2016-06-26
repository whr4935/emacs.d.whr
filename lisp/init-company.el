(provide 'init-company)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company-c-headers                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/5")
;; (add-to-list 'company-backends 'company-c-headers)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; irony                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  (define-key c-mode-map (kbd "C-;") 'company-complete)
  (define-key c++-mode-map (kbd "C-;") 'company-complete)
  (setq company-show-numbers t
        company-tooltip-limit 20
        company-minimum-prefix-length 2
        company-dabbrev-downcase nil
        company-idle-delay nil)

  (add-to-list 'company-backends '(company-irony company-c-headers ;; company-gtags
                                                 ))
  ;; (setq company-backends '((company-irony company-c-headers )))
  )
(add-hook 'after-init-hook 'init-company)

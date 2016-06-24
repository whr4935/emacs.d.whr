(provide 'init-company)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: company              ;;
;;                               ;;
;; GROUP: Convenience -> Company ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun init-company ()
  (global-company-mode)
  (setq company-backends (delete 'company-clang company-backends))
  )

(add-hook 'after-init-hook 'init-company)

;;company-backends

(require 'company-c-headers)

(add-to-list 'company-backends 'company-c-headers t)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/5")


(provide 'init-cedet)

;; CEDET
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-idle-summary-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(require 'stickyfunc-enhance)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

(global-semantic-mru-bookmark-mode)
(defun my-semantic-hook()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

(semantic-mode 1)

(require 'ede)
(global-ede-mode t)

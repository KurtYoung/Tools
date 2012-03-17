;; add ~/.eamcs.d into load-path
;; generally, ~/.emacs.d contains some plugins
(add-to-list 'load-path "~/.emacs.d/")
(load-file "~/.emacs.d/cedet/common/cedet.el")

;; customize color-theme and font
;; need ~/.eamcs.d/color-theme.el 
;; also need export TERM=xterm-256color if start emacs with -nw
;; (require 'color-theme)
;; (color-theme-billw)
;; (set-default-font "monospace-10")

;; add php-mode
;; need ~/.emacs.d/php-mode.el
(require 'php-mode)
(add-hook 'php-mode-user-hook 'turn-on-font-lock)

(global-set-key [f9] '(lambda()
    (interactive)
    (save-some-buffers t)
    (myCompileCmd)
    (compile compile-cmd)
    (shrink-compile-window)
    )
)
(global-set-key [f11] 'my-fullscreen)
(global-set-key "\C-j" 'newline)
(global-set-key "\C-m" 'newline-and-indent)

;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-variables
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "utf-8")
 '(debug-on-error t)
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

;; all backups goto ~/.backups instead in the current directory
(setq backup-directory-alist (quote (("." . "~/.backups"))))

;; share clipboard with outside programs
(setq x-select-enable-clipboard t)

;; open compile window with horizon style
(setq split-height-threshold 0)
(setq split-width-threshold nil)

(setq c-basic-offset 4)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


;; c/c++ related, toggle hungry delete
;; a single <DEL> deletes all preceding whitespace, not just one space
(add-hook 'c++-mode-hook
          '(lambda ( )
             (c-toggle-hungry-state)))
(add-hook 'c-mode-hook
          '(lambda ( )
             (c-toggle-hungry-state)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight space characters at tail
;; set colors
(custom-set-faces
 '(my-tab-face            ((((class color)) (:background "grey10"))) t)
 '(my-trailing-space-face ((((class color)) (:background "gray10"))) t)
 '(my-long-line-face      ((((class color)) (:background "tomato"))) t)
 )

;; define assist function which highlight long lines(>80)
(defun cc-mode-add-keywords (mode)
  (font-lock-add-keywords
   mode
   '(("\t+" (0 'my-tab-face append))
     ("^.\\{81\\}\\(.+\\)$" (1 'my-long-line-face append)))))

;; Only valid in specified mode
(cc-mode-add-keywords 'c-mode)
(cc-mode-add-keywords 'cc-mode)
(cc-mode-add-keywords 'c++-mode)
(cc-mode-add-keywords 'perl-mode)
(cc-mode-add-keywords 'python-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cedet settings
(require 'eassist)
(defun my-c-mode-cedet-hook ()
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-xe" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my functions
(defun my-fullscreen ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_FULLSCREEN" 0))
  )

(defun myCompileCmd()
  (interactive)
  (setq compile_file_name (
      substring (buffer-name (current-buffer))
                0
                (string-match "[.]" (buffer-name (current-buffer)))))
  (setq compile-cmd (
      concat "g++ -g -DDEBUG "
             (buffer-name (current-buffer))
             " && ./a.out"))
  )

(defun shrink-compile-window()
  "shrink compile window, avoid compile window occupy 1/2 hight of whole window"
  (interactive)
  ;;(select-window (get-buffer-window "*compilation*"))
  (setq compiled_buffer_name (buffer-name (current-buffer)))
  (switch-to-buffer-other-window "*compilation*")
  (if (< (/ (frame-height) 3) (window-height))
      (shrink-window (/ (window-height) 2)))
  (switch-to-buffer-other-window compiled_buffer_name)
  )
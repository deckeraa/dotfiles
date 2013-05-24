;; Tell emacs where is your personal elisp lib dir
;; this is the dir you place all your extra packages
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/ESS/lisp/")
(add-to-list 'load-path "~/.emacs.d/perspective-el")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(global-set-key (kbd "C-q") 'beginning-of-line)
(global-set-key (kbd "C-c d") 'org-export-as-pdf)

;; load the packaged named xyz.
(load-file "~/.emacs.d/themes/zenburn-theme.el") ;; best not to include the ending .el or .elc
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doc-view-continuous t)
; '(haskell-mode-hook (quote (turn-on-haskell-indentation turn-on-haskell-doc-mode)))
  (custom-set-variables
  '(haskell-mode-hook '(turn-on-haskell-indentation)))

 '(org-confirm-babel-evaluate nil)
 '(quack-default-program "guile")
 '(quack-programs (quote ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Close an org-mode heading from within
(require 'org) ;; stop error message saying org-mode-map is undefined
(define-key org-mode-map (kbd "C-c t") 'org-cycle-current-headline)
(defun org-cycle-current-headline ()
  (interactive)
  (outline-previous-heading)
  (org-cycle))

;; haskell-mode
(load "~/.emacs.d/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; indentation, only activate one at a time
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

;; cycle through windows using C-(Left Arrow) or C-(Right Arrow)
(defun prev-window ()
  (interactive)
  (other-window -1))

(global-set-key (kbd "C-x p") 'prev-window)
;;(global-set-key "\033[5D" 'prev-window)
;;(global-set-key "\033[5C" 'other-window)

;; Haksell mode indentation stuff
;;(custom-set-variables
;;        '(haskell-mode-hook '(turn-on-haskell-indentation)))    

(defun my-shell (arg)
  (interactive "p")
  (let ((arg (or arg 1)))
    (shell (format "*sh%d*" arg))))

(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z 1") '(lambda () (interactive) (my-shell 1)))
(global-set-key (kbd "C-z 2") '(lambda () (interactive) (my-shell 2)))
(global-set-key (kbd "C-z 3") '(lambda () (interactive) (my-shell 3)))
(global-set-key (kbd "C-z 4") '(lambda () (interactive) (my-shell 4)))
(global-set-key (kbd "C-z 5") '(lambda () (interactive) (my-shell 5)))

(set-default-font "9x15")

;;(load "folding" 'nomessage 'noerror)
;;  (folding-mode-add-find-file-hook)

(global-set-key (kbd "C-c h") 'hs-hide-block)
(global-set-key (kbd "C-c s") 'hs-show-block)

(org-babel-do-load-languages
    'org-babel-load-languages '((python . t) (R . t)(haskell . t)(plantuml . t)(lisp . t)(gnuplot . t)))
(setq org-export-latex-listings t)
(require 'org-latex)
(add-to-list 'org-export-latex-packages-alist '("" "listings"))
(add-to-list 'org-export-latex-packages-alist '("" "color"))

;;(load "blorg")
;;(require blorg)
;;(require 'blorg)

(setq org-src-fontify-natively t)

;; R literate programming
(require 'ess-site)


(load-file "~/.emacs.d/geiser/elisp/geiser.el")

(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
(autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
(autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)

(defun createclass ()
  (interactive)
  (setq classname (file-name-sans-extension (file-name-nondirectory   buffer-file-name)))
  (insert 
"/**
  * " classname".h 
  *
  * Author: Aaron Decker
  * Modified: " (format-time-string "%Y-%m-%d") "
  * Licence: GNU GPL
  */
#ifndef "(upcase classname)"
#define "(upcase classname)"

class " classname "
{
  public:
    "classname"();
    ~"classname"();

  private:

};
#endif
"))

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

;; Scale up formulas
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; o-blog
(require 'htmlize)
(add-to-list 'load-path "~/.emacs.d/o-blog")
(require 'o-blog)
(defun publish-blog-then-compile-less ()
   (interactive)
   (org-publish-blog (buffer-file-name))
   (shell-command 
     "less-compile.sh ./out/style/less"))

(global-set-key (kbd "C-c p") 'publish-blog-then-compile-less)
;;(global-set-key (kbd "C-c p") 'org-publish-blog)

;; microcontroller programming
(defun just-make ()
   (interactive)
   (compile "make -k")
)
(defun just-upload ()
   (interactive)p
   (compile "make upload")
)
(global-set-key (kbd "<f7>") 'just-make)
(global-set-key (kbd "<f8>") 'just-upload)

;; perspective
;; Load Perspective
(require 'perspective)
;; Toggle the perspective mode
(persp-mode)


;;     persp-switch (C-x x s): Switch to a different perspective, or create a new one.
;;     persp-rename (C-x x r): Rename the current perspective.
;;     persp-remove-buffer (C-x x k): Remove a buffer from the current perspective, killing it if it no longer belongs to any perspective.
;;     persp-kill (C-x x c): Kill the current perspective, as well as any buffers belonging only to this perspective.

;; Ido mode
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 0)

;; less-css-mode
(load-file "~/.emacs.d/less-css-mode.el")

;; c++ indentation
(setq-default c-basic-offset 3)

;; spell-checking
(setq ispell-program-name "aspell")
(load-file "~/.emacs.d/ispell.elc")

;; plantUML
(setq org-plantuml-jar-path
      (expand-file-name "~/src/plantuml.jar"))

;; gtags
(defun djcb-gtags-create-or-update ()
  "create or update the gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
    (let ((olddir default-directory)
          (topdir (read-directory-name  
                    "gtags: top of source tree:" default-directory)))
      (cd topdir)
      (shell-command "gtags && echo 'created tagfile'")
      (cd olddir)) ; restore   
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))

(add-hook 'gtags-mode-hook 
  (lambda()
    (local-set-key (kbd "M-.") 'gtags-find-tag)   ; find a tag, also M-.
    (local-set-key (kbd "M-,") 'gtags-find-rtag)))  ; reverse tag

(add-hook 'c-mode-common-hook
  (lambda ()
    (require 'gtags)
    (gtags-mode t)
    (djcb-gtags-create-or-update)))

;;(setq inferior-lisp-program "sbcl")
;;(load (expand-file-name "~/quicklisp/slime-helper.el"))

(setq inferior-lisp-program "/usr/bin/sbcl"
      slime-startup-animation t) ; your Lisp system
(add-to-list 'load-path "~/src/slime") ; your SLIME directory
(require 'slime)
;(slime-setup)
(slime-setup '(slime-fancy slime-asdf))

;;wanderlust
;; ;; wanderlust
;; (autoload 'wl "wl" "Wanderlust" t)
;; (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;; (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; ;; IMAP
;; (setq elmo-imap4-default-server "imap.gmail.com")
;; (setq elmo-imap4-default-user "decker49@gmail.com") 
;; (setq elmo-imap4-default-authenticate-type 'clear) 
;; (setq elmo-imap4-default-port '993)
;; (setq elmo-imap4-default-stream-type 'ssl)

;; (setq elmo-imap4-use-modified-utf7 t) 

;; ;; SMTP
;; (setq wl-smtp-connection-type 'starttls)
;; (setq wl-smtp-posting-port 587)
;; (setq wl-smtp-authenticate-type "plain")
;; (setq wl-smtp-posting-user "decker49")
;; (setq wl-smtp-posting-server "smtp.gmail.com")
;; (setq wl-local-domain "gmail.com")

;; (setq wl-default-folder "%inbox")
;; (setq wl-default-spec "%")
;; (setq wl-draft-folder "%[Gmail]/Drafts") ; Gmail IMAP
;; (setq wl-trash-folder "%[Gmail]/Trash")

;; (setq wl-folder-check-async t) 

;; (setq elmo-imap4-use-modified-utf7 t)

;; (autoload 'wl-user-agent-compose "wl-draft" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'wl-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'wl-user-agent
;;       'wl-user-agent-compose
;;       'wl-draft-send
;;       'wl-draft-kill
;;       'mail-send-hook))

;; gnus
;; (add-to-list 'gnus-secondary-select-methods
;; 	     '(nnimap gmail
;; 		      (nnimap-address imap.gmail.com)
;; 		      (nnimap-server-port 993)
;; 		      (nnimap-stream ssl)))

;; (setq gnus-select-method '(nnimap "gmail" 
;; 				  (nimap-address "imap.gmail.com") 
;; 				  (nimap-server-port 993) 
;; 				  (nimap-stream ssl)))

;; (setq message-send-mail-function 'smtpmail-send-it 
;;       smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)) 
;;       smtpmail-auth-credentials '(("smtp.gmail.com" 587 "decker49@gmail.com" nil)) 
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587 )

(setq starttls-use-gnutls t)

      ;smtpmail-local-domain yourcompany.com)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
(require 'smtpmail)

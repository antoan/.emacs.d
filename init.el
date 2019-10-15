;; This sets up the load path so that we can override it
(package-initialize)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;;(setq org-agenda-files (list "/path/to/dir/file1"))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/bookmarks+"))

(require 'bookmark+)
;;  I recommend that you byte-compile all of the libraries, after loading the source files (in particular, load bookmark+-mac.el).
;; https://www.emacswiki.org/emacs/BookmarkPlus
(byte-recompile-directory "~/.emacs.d/bookmarks+")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(custom-enabled-themes (quote (doom-one)))
 '(custom-safe-themes
   (quote
    ("6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" default)))
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (org-cliplink pocket-reader helm-projectile magit helm org-bullets doom-themes cyberpunk-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (load-theme 'cyberpunk t)

(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)


;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; Org-Mode config
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling

;;[org mode - how to jump directly to an org-headline? - Emacs Stack Exchange](https://emacs.stackexchange.com/questions/32617/how-to-jump-directly-to-an-org-headline/32625)

(setq org-goto-interface 'outline-path-completion)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

(setq org-support-shift-select t)

(global-visual-line-mode 1) ; 1 for on, 0 for off.

(setq org-ditaa-jar-path "~/.emacs.d/ditaa/ditaa0_9.jar")
(setq org-display-inline-images t) 
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ditaa . t)
   (shell . t)
   ))

;;(setq org-capture-templates
;; '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
;;        "* TODO %?\n  %i\n  %a")
;;   ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
;;        "* %?\nEntered on %U\n  %i\n  %a")))


; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))

;; Extended helm config from http://tuhdo.github.io/helm-intro.html
(require 'helm-config)(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

(global-set-key (kbd "C-x g") 'magit-status)

(require 'pocket-reader)

 (setq pocket-reader-url-open-fn-map
    '((eww-browse-url "*")))

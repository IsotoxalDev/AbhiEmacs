(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

;;font config
(set-face-attribute 'default nil :font "mononoki Nerd Font" :height 130)
(set-face-attribute 'fixed-pitch nil :font "mononoki Nerd Font" :height 130)
(set-face-attribute 'variable-pitch nil :font "Roboto" :height 125 :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
(package-refresh-contents))

;; Initialize use-package
(require 'use-package)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Initialize ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Initialize all-the-icons
(use-package all-the-icons)

;; Initialize doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Initialize doom-themes
(use-package doom-themes
  :init (load-theme 'doom-gruvbox t))

;; Initialize rainbow-delimeters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Initialize which-key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Initialize ivy-rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Initialize counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;; Initialize helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Initialize general
(use-package general
  :config
  (general-create-definer abhi/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

;; Initialize evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "n" 'evil-next-visual-line)
  (evil-global-set-key 'motion "e" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  :custom
  (evil-undo-system 'undo-tree))

;; Initializing evil collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-colemak-basics
  :config
  (global-evil-colemak-basics-mode))

;;Initializing hydra
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))
 
;; Initializing Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Dev/")
    (setq projectile-project-search-path '("~/Dev/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Initializing magit
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Initializing forge
(use-package forge
  :after magit)
(setq auth-sources '("~/.authinfo"))

(defun abhi/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

;; Config org-mode
(defun abhi/org-font-setup ()

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Roboto" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

;; Initializing org-mode
(use-package org
  :hook (org-mode . abhi/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/.org/*.org"
	  "~/Dev/*/org/*/org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("Art" . ?a)
       ("Code" . ?c)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "TODO"
             ((org-agenda-files org-agenda-files)))
      (todo "NEXT"
             ((org-agenda-files org-agenda-files)))
      (todo "DONE"
             ((org-agenda-files org-agenda-files))))))

  (setq org-capture-templates
      `(("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/.org/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))
  (abhi/org-font-setup)))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun abhi/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . abhi/org-mode-visual-fill))

;; Keybindings
(abhi/leader-keys
  "s"  '(:ignore s :which-key "Settings")
  "st" '(counsel-load-theme :which-key "Choose theme")
  "ss" '(hydra-text-scale/body :which-key "Scale text")
  "se" '(eval-buffer :which-key "Evaluate Buffer")
  "o"  '(:ignore o :which-key "Org-Mode")
  "oa" '(org-agenda :which-key "Org Agenda")
  "f"  '(:ignore f :which-key "File")
  "ff" '(dired :which-key "Open File")
  "fs" '(save-buffer :which-key "Save File")
  "p"  '(projectile-command-map :which-key "Projectile"))


(add-to-list 'load-path "~/.dotfiles/emacs/scripts/")

(require 'elpaca-setup)  ;; The Elpaca Package Manager

;; (require 'buffer-move)   ;; Buffer-move for better window management

(use-package emacs
  :ensure nil
  :custom                                         ;; Set custom variables to configure Emacs behavior.
  (column-number-mode t)                          ;; Display the column number in the mode line.
  (auto-save-default nil)                         ;; Disable automatic saving of buffers.
  (create-lockfiles nil)                          ;; Prevent the creation of lock files when editing.
  (delete-by-moving-to-trash t)                   ;; Move deleted files to the trash instead of permanently deleting them.
  (delete-selection-mode 1)                       ;; Enable replacing selected text with typed text.
  (display-line-numbers-type 'relative)           ;; Use relative line numbering in programming modes.
  (global-auto-revert-non-file-buffers t)         ;; Automatically refresh non-file buffers.
  (history-length 25)                             ;; Set the length of the command history.
  (inhibit-startup-message t)                     ;; Disable the startup message when Emacs launches.
  (initial-scratch-message "")                    ;; Clear the initial message in the *scratch* buffer.
  (ispell-dictionary "en_US")                     ;; Set the default dictionary for spell checking.
  (make-backup-files nil)                         ;; Disable creation of backup files.
  (pixel-scroll-precision-mode t)                 ;; Enable precise pixel scrolling.
  (pixel-scroll-precision-use-momentum nil)       ;; Disable momentum scrolling for pixel precision.
  (ring-bell-function 'ignore)                    ;; Disable the audible bell.
  (split-width-threshold 300)                     ;; Prevent automatic window splitting if the window width exceeds 300 pixels.
  (switch-to-buffer-obey-display-actions t)       ;; Make buffer switching respect display actions.
  (tab-always-indent 'complete)                   ;; Make the TAB key complete text instead of just indenting.
  (tab-width 4)                                   ;; Set the tab width to 4 spaces.
  (treesit-font-lock-level 4)                     ;; Use advanced font locking for Treesit mode.
  (truncate-lines t)                              ;; Enable line truncation to avoid wrapping long lines.
  (use-dialog-box nil)                            ;; Disable dialog boxes in favor of minibuffer prompts.
  (use-short-answers t)                           ;; Use short answers in prompts for quicker responses (y instead of yes)
  (warning-minimum-level :emergency)              ;; Set the minimum level of warnings to display.
  (split-width-threshold 120)                     ;; Make new windows open to the right

  :hook                                           ;; Add hooks to enable specific features in certain modes.
  (prog-mode . display-line-numbers-mode)         ;; Enable line numbers in programming modes.

  :config
  ;; By default emacs gives you access to a lot of *special* buffers, while navigating with [b and ]b,
  ;; this might be confusing for newcomers. This settings make sure ]b and [b will always load a
  ;; file buffer. To see all buffers use <leader> SPC, <leader> b l, or <leader> b i.
  (defun skip-these-buffers (_window buffer _bury-or-kill)
    "Function for `switch-to-prev-buffer-skip'."
    (string-match "\\*[^*]+\\*" (buffer-name buffer)))
  (setq switch-to-prev-buffer-skip 'skip-these-buffers)


  
  ;; Save manual customizations to a separate file instead of cluttering `init.el'.
  ;; You can M-x customize, M-x customize-group, or M-x customize-themes, etc.
  ;; The saves you do manually using the Emacs interface would overwrite this file.
  ;; The following makes sure those customizations are in a separate file.
  (setq custom-file (locate-user-emacs-file "custom-vars.el")) ;; Specify the custom file path.
  (load custom-file 'noerror 'nomessage)                       ;; Load the custom file quietly, ignoring errors.

  ;; Makes Emacs vertical divisor the symbol │ instead of |.
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

  :init                        ;; Initialization settings that apply before the package is loaded.
  (tool-bar-mode -1)           ;; Disable the tool bar for a cleaner interface.
  (menu-bar-mode -1)           ;; Disable the menu bar for a more streamlined look.

  (when scroll-bar-mode
    (scroll-bar-mode -1))      ;; Disable the scroll bar if it is active.

  (global-hl-line-mode 1)      ;; Enable highlight of the current line
  (global-auto-revert-mode 1)  ;; Enable global auto-revert mode to keep buffers up to date with their corresponding files.
  (indent-tabs-mode -1)        ;; Disable the use of tabs for indentation (use spaces instead).
  (recentf-mode 1)             ;; Enable tracking of recently opened files.
  (savehist-mode 1)            ;; Enable saving of command history.
  (save-place-mode 1)          ;; Enable saving the place in files for easier return.
  (winner-mode 1)              ;; Enable winner mode to easily undo window configuration changes.
  (xterm-mouse-mode 1)         ;; Enable mouse support in terminal mode.
  (file-name-shadow-mode 1)    ;; Enable shadowing of filenames for clarity.

  ;; Set the default coding system for files to UTF-8.
  (modify-coding-system-alist 'file "" 'utf-8)

  ;; Add a hook to run code after Emacs has fully initialized.
  (add-hook 'after-init-hook
            (lambda ()
              (message "Emacs has fully loaded. This code runs after startup.")

              ;; Insert a welcome message in the *scratch* buffer displaying loading time and activated packages.
              (with-current-buffer (get-buffer-create "*scratch*")
                (insert (format
                         ";;    Welcome to Emacs!
;;
;;    Loading time : %s
;;    Packages     : %s
"
                         (emacs-init-time)
                         (number-to-string (length package-activated-list))))))))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package modus-themes
	:ensure (:wait t))

;; (load-theme 'modus-operandi)
;; (load-theme 'modus-operandi-tinted)
(load-theme 'modus-vivendi)

(use-package doom-modeline
  :ensure t
  :defer t
  :custom
  (doom-modeline-buffer-file-name-style 'buffer-name)  ;; Set the buffer file name style to just the buffer name (without path).
  (doom-modeline-project-detection 'project)           ;; Enable project detection for displaying the project name.
  (doom-modeline-buffer-name t)                        ;; Show the buffer name in the mode line.
  (doom-modeline-vcs-max-length 25)                    ;; Limit the version control system (VCS) branch name length to 25 characters.
  :config
  (setq doom-modeline-icon t)                      ;; Enable icons in the mode line if nerd fonts are used.
  (setq doom-modeline-icon nil)                     ;; Disable icons if nerd fonts are not being used.
  :hook
  (after-init . doom-modeline-mode))

(set-face-attribute 'default nil :family "Iosevka Term Curly"  :height 130)
;; (set-face-attribute 'default nil :family "Iosevka Term Curly" :height 150))

(set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 100)
;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

(use-package which-key
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-allow-imprecise-window-fit nil
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " ))

(use-package general
  :demand t
  :after evil
  :config

  (general-create-definer mb/leader-key-def
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

  (general-create-definer mb/local-leader-keys
  :prefix "C-c")

  (general-create-definer mb/programming-key-def
  :keymaps '(lsp-mode-map)
  :prefix "SPC")
  
;; Buffer Management
(mb/leader-key-def
  "b"       '(:ignore t                       :which-key "Buffer")
  "b i"     '(consult-buffer                  :which-key "Consult buffer list")
  "b b"     '(ibuffer                         :which-key "IBuffer")
  "b k"     '(kill-current-buffer             :which-key "Kill current buffer")
  "SPC"     '(consult-buffer                  :which-key "Consult buffer"))

;; Edit files
(mb/leader-key-def
  "e"       '(:ignore t                                             :which-key "Edit files")
  "e c"     '((lambda () (interactive)
			  (find-file "~/.emacs.d/emacs.org"))                   :which-key "Emacs Config")
  "e i"     '((lambda () (interactive)
			  (find-file "~/Documenten/org/roamnotes/Inbox.org"))   :which-key "Inbox"))

;; File Management
(mb/leader-key-def
  "f"       '(:ignore t                       :which-key "Files")
  "f f"     '(find-file                       :which-key "Open file")
  "f r"     '(consult-recent-file             :which-key "Recent file"))

(mb/leader-key-def
  "h"       '(:ignore t                       :which-key "Help")
  "h f"     '(describe-function               :which-key "Describe function")
  "h F"     '(describe-face                   :which-key "Describe face")
  "h k"     '(describe-key                    :which-key "Describe key")
  "h m"     '(describe-mode                   :which-key "Describe mode")
  "h v"     '(describe-variable               :which-key "Describe variable"))

(mb/leader-key-def
  "o"       '(:ignore t                       :which-key "Org")
  "o c"     '((lambda () (interactive)
			 (mb/org-roam-capture-inbox))     :which-key "Capture to inbox")
  "o j"     '(:ignore t                       :which-key "Journal")
  "o j j"   '(org-roam-dailies-capture-today  :which-key "New journal entry")
  "o r"     '(:ignore t                       :which-key "Roam")
  "o r f"   '(org-roam-node-find              :which-key "Org roam find node")
  "o r i"   '(org-roam-node-insert            :which-key "Org roam insert node"))

;; LSP mode / Programming
(mb/programming-key-def
  "p"       '(:ignore t                       :which-key "Programming")
  "p d"     '((lambda () (interactive)
				(mb/lsp-describe-and-jump))   :which-key "Open hover doc")
  "p f"     '(lsp-find-references             :which-key "Find references")
  "p r"     '(lsp-rename                      :which-key "Rename"))

  ;; Searching
(mb/leader-key-def
  "s"       '(:ignore t                       :which-key "Search")
  "s f"     '(consult-find                    :which-key "Search files in dir")
  "s g"     '(consult-grep                    :which-key "Search with grep")
  "s m"     '(consult-info                    :which-key "Search in manuals")
  "s l"     '(consult-line                    :which-key "Search line"))

;; Elfeed RSS
(mb/local-leader-keys
  "e"       '(:ignore t                       :which-key "Elfeed RSS")
  "e o"     '(elfeed                          :which-key "Elfeed")
  "e u"     '(elfeed-update                   :which-key "Update feeds")
  "e b"     '(elfeed-search-browse-url        :which-key "Open in browser"))
  )

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
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  ;; Same for up/down keys
  (define-key evil-normal-state-map (kbd "<down>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<up>") 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

  (use-package evil-collection
    :after evil
    :init
    (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
    :config
    (evil-collection-init))

  ;; Using RETURN to follow links in Org/Evil 
  ;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
  (with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
  ;; Setting RETURN key in org-mode to follow links
  (setq org-return-follows-link  t)



;;; In-buffer completion (using complete-at-point-functions): corfu

(use-package corfu
  :ensure (:files (:defaults "extensions/*"))
  :demand t                      ; need this when using :bind or :hook
  :config
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.75)
  (corfu-quit-no-match t) ; quit when the popup appears and I type anything else
  ;; Might want to customize corfu-sort-function
  :bind
  (("M-RET" . completion-at-point)
   )
  )

;; corfu extension (in corfu/extensions/corfu-history.el); load after corfu
(use-package corfu-history
  :ensure nil
  :after corfu
  :config
  (corfu-history-mode)
  (savehist-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)
)

(use-package corfu-terminal
  :after corfu
  :init
  (defvar corfu-terminal-mode)
  ;; TODO set this up, for use in non-GUI emacs
  )

;; Additional capf completion sources
(use-package cape
  :config
  ;; Note: order matters here. First one returning a result wins. Use
  ;; ~add-hook~ to add these, since it sets the global (default) value
  ;; of capf, instead of ~setq~ which would make it buffer-local
  ;; (which would be bad): capf is automatically buffer-local when
  ;; set.
  ;; The buffer-local value, which takes precedence over these, calls these as long
  ;; as it ends with ~t~.
  (add-hook 'completion-at-point-functions #'cape-history)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (message (format "Loading my capf extensions: %s" completion-at-point-functions))
  )

;; Nice icons for corfu popups
(use-package kind-icon
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package vertico
  :demand t
  :init (vertico-mode)           ;; Enable vertico after Emacs has initialized.
  :custom
  (vertico-count 10)                    ;; Number of candidates to display in the completion list.
  (vertico-resize nil)                  ;; Disable resizing of the vertico minibuffer.
  (vertico-cycle nil)                   ;; Do not cycle through candidates when reaching the end of the list.
  :config
  ;; Customize the display of the current candidate in the completion list.
  ;; This will prefix the current candidate with “» ” to make it stand out.
  ;; Reference: https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face '(:foreground "#80adf0" :weight bold))
                   "  ")
                 cand))))

(use-package orderless
  :ensure t
  :defer t                                    ;; Load Orderless on demand.
  :after vertico                              ;; Ensure Vertico is loaded before Orderless.
  :init
  (setq completion-styles '(orderless basic)  ;; Set the completion styles.
        completion-category-defaults nil      ;; Clear default category settings.
        completion-category-overrides '((file (styles partial-completion))))) ;; Customize file completion styles.

(use-package marginalia
  :demand t
  :init (marginalia-mode))

(use-package embark
  :ensure t
  :defer t)

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)) ;; Enable preview in Embark collect mode.

(use-package org
  :ensure nil
  :config
  (setq org-startup-folded 'content))

(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(require 'org-tempo)
  
(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("ni" . "src nix"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("r"  . "src rust"))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(setq org-directory "~/Documenten/org"
        org-roam-directory "~/Documenten/org/notes"                  ;; Needed for org-roam and deft
        org-default-notes-file "~/Documenten/org/notes/main.org"     ;; Not sure if needed
        org-agenda-files '("~/Documenten/org/roamnotes/Inbox.org"
			"~/Documenten/org/roamnotes/Inbox.org_archive" ;; Just to show old items in agenda
                        "~/Documenten/org/roamnotes/Praktijkopleider.org"
                        "~/Documenten/org/roamnotes/Agenda.org"
			"~/Documenten/org/roamnotes/Calendar.org"
                        "~/Documenten/org/roamnotes/Werkbegeleider.org"))
        ;; org-agenda-files (list "~/Documenten/org/"))                ;; Specify files that go in the calendar

;; Make sure everyday has a timegrid irrespective of appointments (require-timed)
(setq org-agenda-time-grid '((daily today weekly)
                            (800 1000 1200 1400 1600 1800 2000)
                                "......" "----------------"))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-agenda-custom-commands

            '(("g" "Week - Get Things Done (GTD)"
               ((agenda ""
                        ((org-agenda-skip-function
                          '(org-agenda-skip-entry-if 'deadline))
                         (org-agenda-prefix-format "  %i %-18:c%?-12t% s")
                         (org-deadline-warning-days 0)
                         (org-agenda-time-grid '((daily today weekly require-timed)
                                    (800 1000 1200 1400 1600 1800 2000)
                                        "......" "----------------"))))
                (todo "BUSY"
                      ((org-agenda-skip-function
                        '(org-agenda-skip-entry-if 'deadline))
                       (org-agenda-prefix-format "  %i %-18:c [%e] ")
                       (org-agenda-overriding-header "\nTasks\n")))
                (todo "TODO"
                      ((org-agenda-skip-function
                        '(org-agenda-skip-entry-if 'deadline))
                       (org-agenda-prefix-format "  %i %-18:c [%e] ")
                       (org-agenda-overriding-header "\nTasks\n")))
                ;; (tags-todo "inbox"
                ;;            ((org-agenda-prefix-format "  %?-12t% s")
                ;;             (org-agenda-overriding-header "\nInbox\n")))
                (tags "CLOSED>=\"<today>\""
                      ((org-agenda-overriding-header "\nCompleted today\n"))))
      		  nil
    		  ("~/Documenten/org/weekagenda.html"))
             ("d" "Day - Get Things Done (GTD)"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-agenda-prefix-format "  %i %-18:c%?-12t% s")
                   (org-agenda-span 1)
                   (org-deadline-warning-days 0)
                   (org-agenda-time-grid '((daily today weekly require-timed)
                              (800 1000 1200 1400 1600 1800 2000)
                                  "......" "----------------"))))
          (todo "BUSY"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-18:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
           (todo "TODO"
                 ((org-agenda-skip-function
                   '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-18:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          ;; (tags-todo "inbox"
          ;;            ((org-agenda-prefix-format "  %?-12t% s")
          ;;             (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n"))))
  		  nil
		  ("~/Documenten/org/dagagenda.html"))))

(use-package htmlize
  :ensure t)

(setq org-capture-templates
      `(("t" "Todo (persoonlijk)" entry  (file+headline "~/Documenten/org/roamnotes/Inbox.org" "Tasks")
         ,(concat "* TODO %?\n"
              "/Entered on/ %U"))
		("w" "Todo (werk)" entry  (file+headline "~/Documenten/org/roamnotes/Inbox.org" "Werk")
         ,(concat "* TODO %?\n"
              "/Entered on/ %U"))))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documenten/org/roamnotes")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%H:%M %p>\n %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
    :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"    . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

  (setq org-roam-dailies-directory "journal/")

(defun mb/org-roam-capture-inbox ()
(interactive)
(org-roam-capture- :node (org-roam-node-create)
    :templates '(("t" "todo")
                 ("ti" "Add TODO to inbox" plain "** TODO %?\n"
                 :if-new (file+olp "Inbox.org" ("TASKS")))
                 ("tp" "Add TODO praktijkopleider" plain "** TODO %?\n"
                 :if-new (file+olp "Praktijkopleider.org" ("TASKS")))
                 ("tw" "Add TODO Werkbegeleider" plain "** TODO %?\n"
                 :if-new (file+olp "Werkbegeleider.org" ("TASKS"))))))

;; TODO change this to leader-key-def "<leader> o c"
(global-set-key (kbd "C-c n b") #'mb/org-roam-capture-inbox)

(setq org-todo-keywords
    '((sequence "TODO(t)" "BUSY(b)" "PAUSE(p)" "|" "DONE(d)")))

(push "~/.config/private" load-path)
(require 'org-gcal-credentials)

(use-package lsp-mode
   :ensure t
   :defer t
   :hook (;; Replace XXX-mode with concrete major mode (e.g. python-mode)
          (bash-ts-mode . lsp)                           ;; Enable LSP for Bash
          (python-mode . lsp-deferred)                   ;; Enable Python
          (typescript-ts-mode . lsp)                     ;; Enable LSP for TypeScript
          (tsx-ts-mode . lsp)                            ;; Enable LSP for TSX
          (js-mode . lsp)                                ;; Enable LSP for JavaScript
          (js-ts-mode . lsp)                             ;; Enable LSP for JavaScript (TS mode)
          (lsp-mode . lsp-enable-which-key-integration)) ;; Integrate with Which Key
   :commands lsp
   :custom
   (lsp-keymap-prefix "C-c l")                           ;; Set the prefix for LSP commands.
   (lsp-inlay-hint-enable t)                             ;; Enable inlay hints.
   (lsp-completion-provider :none)                       ;; Disable the default completion provider.
   (lsp-session-file (locate-user-emacs-file ".lsp-session")) ;; Specify session file location.
   (lsp-log-io nil)                                      ;; Disable IO logging for speed.
   (lsp-idle-delay 0)                                    ;; Set the delay for LSP to 0 (debouncing).
   (lsp-keep-workspace-alive nil)                        ;; Disable keeping the workspace alive.
   ;; Core settings
   (lsp-enable-xref t)                                   ;; Enable cross-references.
   (lsp-auto-configure t)                                ;; Automatically configure LSP.
   (lsp-enable-links nil)                                ;; Disable links.
   (lsp-eldoc-enable-hover t)                            ;; Enable ElDoc hover.
   (lsp-enable-file-watchers nil)                        ;; Disable file watchers.
   (lsp-enable-folding nil)                              ;; Disable folding.
   (lsp-enable-imenu t)                                  ;; Enable Imenu support.
   (lsp-enable-indentation nil)                          ;; Disable indentation.
   (lsp-enable-on-type-formatting nil)                   ;; Disable on-type formatting.
   (lsp-enable-suggest-server-download t)                ;; Enable server download suggestion.
   (lsp-enable-symbol-highlighting t)                    ;; Enable symbol highlighting.
   (lsp-enable-text-document-color nil)                  ;; Disable text document color.
   ;; Modeline settings
   (lsp-modeline-code-actions-enable nil)                ;; Keep modeline clean.
   (lsp-modeline-diagnostics-enable nil)                 ;; Use `flymake' instead.
   (lsp-modeline-workspace-status-enable t)              ;; Display "LSP" in the modeline when enabled.
   (lsp-signature-doc-lines 1)                           ;; Limit echo area to one line.
   (lsp-eldoc-render-all nil)                              ;; Render all ElDoc messages.
   ;; Completion settings
   (lsp-completion-enable t)                             ;; Enable completion.
   (lsp-completion-enable-additional-text-edit t)        ;; Enable additional text edits for completions.
   (lsp-enable-snippet nil)                              ;; Disable snippets
   (lsp-completion-show-kind t)                          ;; Show kind in completions.
   ;; Lens settings
   (lsp-lens-enable t)                                   ;; Enable lens support.
   ;; Headerline settings
   (lsp-headerline-breadcrumb-enable-symbol-numbers t)   ;; Enable symbol numbers in the headerline.
   (lsp-headerline-arrow "▶")                            ;; Set arrow for headerline.
   (lsp-headerline-breadcrumb-enable-diagnostics nil)    ;; Disable diagnostics in headerline.
   (lsp-headerline-breadcrumb-icons-enable nil)          ;; Disable icons in breadcrumb.
   ;; Semantic settings
   (lsp-semantic-tokens-enable nil))                     ;; Disable semantic tokens.

(defun mb/lsp-describe-and-jump ()
   "Show hover documentation and jump to *lsp-help* buffer."
   (interactive)
   (lsp-describe-thing-at-point)
   (let ((help-buffer "*lsp-help*"))
     (when (get-buffer help-buffer)
       (switch-to-buffer-other-window help-buffer))))

(use-package eldoc
  :ensure nil          ;; This is built-in, no need to fetch it.
  :init
  (global-eldoc-mode))

(use-package flymake
  :ensure nil          ;; This is built-in, no need to fetch it.
  :defer t
  :hook (prog-mode . flymake-mode)
  :custom
  (flymake-margin-indicators-string
   '((error "!»" compilation-error) (warning "»" compilation-warning)
     (note "»" compilation-info))))

(use-package treesit-auto
  :ensure t
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

(use-package lsp-tailwindcss
  :ensure t
  :defer t
  :config
  (add-to-list 'lsp-language-id-configuration '(".*\\.erb$" . "html")) ;; Associate ERB files with HTML.
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package markdown-mode
  :defer t
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)            ;; Use gfm-mode for README.md files.
  :init (setq markdown-command "multimarkdown")) ;; Set the Markdown processing command.

(add-hook 'text-mode-hook 'visual-line-mode)

(use-package add-node-modules-path
  :ensure t
  :defer t
  :custom
  ;; Makes sure you are using the local bin for your
  ;; node project. Local eslint, typescript server...
  (eval-after-load 'typescript-ts-mode
    '(add-hook 'typescript-ts-mode-hook #'add-node-modules-path))
  (eval-after-load 'tsx-ts-mode
    '(add-hook 'tsx-ts-mode-hook #'add-node-modules-path))
  (eval-after-load 'typescriptreact-mode
    '(add-hook 'typescriptreact-mode-hook #'add-node-modules-path))
  (eval-after-load 'js-mode
    '(add-hook 'js-mode-hook #'add-node-modules-path)))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package transient)

(use-package magit
  :after transient
  :defer t)

(use-package elfeed
  :config
  (setq elfeed-search-feed-face ":foreground #ffffff :weight bold"
        elfeed-feeds (quote
                       (("https://www.reddit.com/r/linux.rss" reddit linux)
                        ("https://www.reddit.com/r/emacs.rss" reddit emacs)
                        ("https://opensource.com/feed" opensource linux)
                        ))))
 

(use-package elfeed-goodies
  :init
  (elfeed-goodies/setup)
  :config
  (setq elfeed-goodies/entry-pane-size 0.5))

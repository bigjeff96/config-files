(setq read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      lsp-idle-delay 0.01)
(setq gc-cons-threshold 100000000)
(setq package-install-upgrade-built-in t)
;; (setenv "LSP_USE_PLISTS" "true")
(setq lsp-log-io nil)
(setq lsp-enable-file-watchers nil) 
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(setq make-backup-files nil)
(display-time-mode 1)
(display-battery-mode)
(savehist-mode 1)
(server-start)
(add-hook 'emacs-startup-hook 'vterm)
(set-language-environment "UTF-8")
(set-face-attribute 'default nil :height 115)
(defalias 'yes-or-no-p 'y-or-n-p)
(load-theme 'deeper-blue)
(setq ring-bell-function 'ignore)
(setq column-number-mode t)

(let ((path (shell-command-to-string ". ~/.bashrc; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path
        (append
         (split-string-and-unquote path ":")
         exec-path)))

(when (daemonp)
  (exec-path-from-shell-initialize))
(global-auto-revert-mode 1)
(fancy-compilation-mode 1)
(setq resize-mini-windows t)

(global-set-key (kbd "C-c C-x") 'multi-vterm-dedicated-toggle)

;; fullscreen a buffer
(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_) 
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
(global-set-key (kbd "S-C-f") 'toggle-maximize-buffer)
;; you can cd to the directory where your previous buffer file exists
;; after you have toggle to the vterm buffer with `vterm-toggle'.
(require 'vterm)
(define-key vterm-mode-map [(control return)]   #'vterm-toggle-insert-cd)

;Switch to next vterm buffer
(define-key vterm-mode-map (kbd "s-n")   'vterm-toggle-forward)
;Switch to previous vterm buffer
(define-key vterm-mode-map (kbd "s-p")   'vterm-toggle-backward)

(cua-mode t)
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
; when Smex is auto-initialized on its first run.
(global-set-key (kbd "C-w") 'kill-whole-line)
(global-set-key (kbd "C-q") 'kill-this-buffer)
(global-set-key (kbd "C-S-g") 'goto-line)
(global-set-key (kbd "C-S-s") 'save-buffer)
(global-set-key (kbd "C-x C-b") 'ivy-switch-buffer)
(require 'counsel)
(global-set-key (kbd "M-x") 'counsel-M-x)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(global-company-mode 1)
(define-key company-active-map (kbd "<tab>") 'company-complete-selection)
(defun my-shell-mode-setup-function ()
  (company-mode -1))
;; (add-to-list 'company-backends 'company-etags)
(add-hook 'shell-mode-hook 'my-shell-mode-setup-function)
(add-hook 'eshell-mode-hook 'my-shell-mode-setup-function)
(add-hook 'term-mode-hook 'my-shell-mode-setup-function)
(vterm)
(global-undo-tree-mode +1)
(global-set-key (kbd "M-z") 'undo-tree-redo)
;;TODO: put undo files in .emacs directory
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq create-lockfiles nil)
(projectile-mode +1)
(setq projectile-use-git-grep nil)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)                                        
(which-key-mode 1)
(show-paren-mode 1)

(defadvice show-paren-function (after my-echo-paren-matching-line activate)
  "If a matching paren is off-screen, echo the matching line."
  (when (char-equal (char-syntax (char-before (point))) ?\))
    (let ((matching-text (blink-matching-open)))
      (when matching-text
        (message matching-text)))))

(require 'move-text)
(move-text-default-bindings)
(setq lsp-keymap-prefix "C-c l")
;; (setq lsp-clients-clangd-args '(
;;                                   ;; If set to true, code completion will include index symbols that are not defined in the scopes
;;                                   ;; (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
;;                                   ;; "--all-scopes-completion"
;;                                   ;; Index project code in the background and persist index on disk.
;;                                   ;; "--background-index"
;;                                   ;; Enable clang-tidy diagnostics
;;                                   ;; "--clang-tidy"
;;                                   ;; Whether the clang-parser is used for code-completion
;;                                   ;;   Use text-based completion if the parser is not ready (auto)
;;                                   "--completion-parse=auto"
;;                                   ;; Granularity of code completion suggestions
;;                                   ;;   One completion item for each semantically distinct completion, with full type information (detailed)
;;                                   ;; "--completion-style=detailed"
;;                                   ;; clang-format style to apply by default when no .clang-format file is found
;;                                   ;; "--fallback-style=Chromium"
;;                                   ;; When disabled, completions contain only parentheses for function calls.
;;                                   ;; When enabled, completions also contain placeholders for method parameters
;;                                   "--function-arg-placeholders"
;;                                   ;; Add #include directives when accepting code completions
;;                                   ;;   Include what you use. Insert the owning header for top-level symbols, unless the
;;                                   ;;   header is already directly included or the symbol is forward-declared
;;                                   ;; "--header-insertion=iwyu"
;;                                   ;; Prepend a circular dot or space before the completion label, depending on whether an include line will be inserted or not
;;                                   ;; "--header-insertion-decorators"
;;                                   ;; Enable index-based features. By default, clangd maintains an index built from symbols in opened files.
;;                                   ;; Global index support needs to enabled separatedly
;;                                   ;; "--index"
;;                                   ;; Attempts to fix diagnostic errors caused by missing includes using index
;;                                   ;; Number of async workers used by clangd. Background index also uses this many workers.
;;                                   ;; "-j=1"
;; 				  "--header-insertion=never"
;;                                   ))
(use-package lsp-mode
  :hook ((c-mode . lsp-deferred)
	 (python-mode . lsp-deferred))
    :commands (lsp lsp-deferred))
(setq lsp-diagnostics-provider :none)
(setq lsp-inlay-hint-enable nil)
(setq lsp-eldoc-render-all nil)
(setq lsp-eldoc-enable-hover t)
(setq lsp-completion-enable-additional-text-edit nil)
(require 'yasnippet)
(yas-global-mode 1)
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
(require 'lsp-ivy)
(global-set-key (kbd "M-S-s") 'lsp-ivy-workspace-symbol)
(global-set-key (kbd "M-s") 'lsp-ivy-workspace-symbol)
(global-set-key (kbd "M-f") 'lsp-find-references)
(global-set-key (kbd "M-S-f") 'lsp-find-references)
(global-set-key (kbd "M-S-o") 'counsel-projectile-find-file)
(global-set-key (kbd "M-o") 'counsel-projectile-find-file)
(global-set-key (kbd "M-S-g") 'counsel-projectile-rg)
(global-set-key (kbd "M-g") 'counsel-projectile-rg)
(global-set-key (kbd "C-S-b") 'ff-find-other-file)
(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\|NOTE\\|COMMENT\\|HOW\\):" 1 font-lock-warning-face t)))))
(setq default-tab-width 4)
(setq c-basic-offset 4)

(ivy-mode 1)
(require 'swiper)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'anzu-query-replace)
;; (global-diff-hl-mode)

(use-package goto-chg
  :bind ("C-." . goto-last-change))

;; (require 'helm-projectile)
;; (helm-projectile-on)
(require 'counsel-projectile)
(counsel-projectile-mode 1)

(defun my-next-error ()
  "Move point to next error and highlight it"
  (interactive)
  (progn
    (next-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)))

(defun my-previous-error ()
  "Move point to previous error and highlight it"
  (interactive)
  (progn
    (previous-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)))

(global-set-key (kbd "C-S-x") 'my-next-error)
(global-set-key (kbd "C-S-z") 'my-previous-error)
(global-set-key (kbd "C-S-c") 'recompile)
(add-hook 'compilation-mode-hook 'hide-mode-line-mode)
(add-hook 'compilation-mode-hook 'visual-line-mode)
(add-hook 'compilation-mode-hook #'(lambda()
                                     (interactive)
    (text-scale-set -1)))
(setq compilation-scroll-output nil)

(defun fuzzy-compile ()
  "Compile with completing options."
  (interactive)
  (let ((hist-compile-command (completing-read "Compile command: " compile-history)))
    (compile hist-compile-command)
    (add-to-list 'compile-history hist-compile-command)
    (set compile-command hist-compile-command)))

(add-to-list
 'display-buffer-alist
 '("\\*compilation\\*" display-buffer-reuse-window
                         (reusable-frames . t)))

(define-derived-mode magit-staging-mode magit-status-mode "Magit staging"
  "Mode for showing staged and unstaged changes."
  :group 'magit-status)
(defun magit-staging-refresh-buffer ()
  (magit-insert-section (status)
    (magit-insert-untracked-files)
    (magit-insert-unstaged-changes)
    (magit-insert-staged-changes)))
(defun magit-staging ()
  (interactive)
  (magit-mode-setup #'magit-staging-mode))

(add-hook 'org-mode-hook 'visual-line-mode)
(require 'org-superstar)
(add-hook 'org-mode-hook 'org-superstar-mode)
(setq org-superstar-headline-bullets-list '("●" "●" "●" "●"))
(use-package olivetti
  :ensure t
  :config
  (defun distraction-free ()
    "Distraction-free writing environment"
    (interactive)
    (if (equal olivetti-mode nil) (progn
                                    (delete-other-windows)
                                    (olivetti-mode t)
				    (text-scale-set +1)
				    (hide-mode-line-mode t)
                                    (setq olivetti-body-width 85))
      (progn
	(olivetti-mode 0)
	(text-scale-set 0)
	(hide-mode-line-mode -1)))
  (global-set-key (kbd "<f6>") 'distraction-free)))
(setq org-startup-indented t
      org-ellipsis "↵" ;folding symbol
      org-hide-emphasis-markers t
      org-agenda-block-seperator ""
      org-image-actual-width 400
      org-return-follows-link  t
      org-tags-column -60)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(require 'flyspell)
(setq flyspell-prog-text-faces
      (delq 'font-lock-string-face
            flyspell-prog-text-faces))
(define-key global-map [remap flyspell-auto-correct-previous-word] 'comment-line)
(global-set-key (kbd "C-;") 'comment-line)

(byte-compile-file "~/.emacs.d/elpa/crux-0.4.0/crux.el" 'load)
;;smartparens
(require 'smartparens)
(smartparens-global-mode)
(sp-pair "(" ")" :wrap "C-S-w")
(global-set-key (kbd "C-S-q") 'sp-unwrap-sexp)
(define-key smartparens-mode-map [remap sp-backward-slurp-sexp] 'sp-backward-down-sexp)
(define-key smartparens-mode-map [remap sp-forward-slurp-sexp] 'sp-up-sexp)
(global-set-key (kbd "C-)") 'sp-up-sexp)
(global-set-key (kbd "C-(") 'sp-backward-down-sexp)
(global-set-key (kbd "C-O") 'backward-up-list)
(global-set-key (kbd "C-P") 'forward-list)
(global-set-key (kbd "C-S-e") 'forward-sexp)
(global-set-key (kbd "C-S-a") 'backward-sexp)
(global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
(global-set-key [(shift return)] #'crux-smart-open-line)
(global-set-key (kbd "s-r") #'crux-recentf-find-file)
(global-set-key (kbd "C-<backspace>") #'crux-kill-line-backwards)
(global-set-key [remap kill-whole-line] #'crux-kill-whole-line)

(global-set-key (kbd "C-M-<right>") 'windmove-right)
(global-set-key (kbd "C-M-<left>") 'windmove-left)
(global-set-key (kbd "C-M-<up>") 'windmove-up)
(global-set-key (kbd "C-M-<down>") 'windmove-down)

;; modified C-backspace
(defun ryanmarcus/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-back "[ \n]")
               (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))

(global-set-key [C-backspace] 'ryanmarcus/backward-kill-word)

(defun ryanmarcus/forward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-at "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-at "[ \n]")
               (delete-forward-char 1)))
    ;; otherwise, just do the normal kill word.
    (kill-word 1)))

(global-set-key [C-delete] 'ryanmarcus/forward-kill-word)

(defalias 'ff 'find-file)
(defalias 'op 'counsel-find-file)
(defalias 'd 'dired-current-directory)

(require 'workgroups2)
(setq wg-prefix-key (kbd "C-c z"))
(workgroups-mode 1)
(winner-mode 1)
(require 'harpoon)
;; trying out harpoon
;; You can use this hydra menu that have all the commands
(global-set-key (kbd "C-c a") 'harpoon-quick-menu-hydra)
(global-set-key (kbd "C-c h <return>") 'harpoon-add-file)

;; And the vanilla commands
(global-set-key (kbd "C-c h f") 'harpoon-toggle-file)
(global-set-key (kbd "C-c h h") 'harpoon-toggle-quick-menu)
(global-set-key (kbd "C-c h c") 'harpoon-clear)
(global-set-key (kbd "M-1") 'harpoon-go-to-1)
(global-set-key (kbd "M-2") 'harpoon-go-to-2)
(global-set-key (kbd "M-3") 'harpoon-go-to-3)
(global-set-key (kbd "M-4") 'harpoon-go-to-4)
(global-set-key (kbd "M-5") 'harpoon-go-to-5)
(global-set-key (kbd "M-6") 'harpoon-go-to-6)
(global-set-key (kbd "M-7") 'harpoon-go-to-7)
(global-set-key (kbd "M-8") 'harpoon-go-to-8)
(global-set-key (kbd "M-9") 'harpoon-go-to-9)

;; odin mode
;; Odin lang
(byte-compile-file "/home/joe/.emacs.d/odin-mode.el" 'load)
;; ;; odin lsp
;; ;; With odin-mode (https://github.com/mattt-b/odin-mode) and lsp-mode already added to your init.el of course!.
;; ;; With odin-mode (https://github.com/mattt-b/odin-mode) and lsp-mode already added to your init.el of course!.
;; (setq-default lsp-auto-guess-root t) ;; if you work with Projectile/project.el this will help find the ols.json file.
(defvar lsp-language-id-configuration '((odin-mode . "odin")))
(require 'lsp-mode)
(add-to-list 'lsp-language-id-configuration '(odin-mode . "odin"))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "/home/joe/Projects/ols/ols")
                  :major-modes '(odin-mode)
                  :server-id 'ols
                  :multi-root t)) ;; This is just so lsp-mode sends the "workspaceFolders" param to the server.
(add-hook 'odin-mode-hook #'lsp)

(defvar lsp-language-id-configuration '((c++-mode . "cpp")))
(require 'lsp-mode)
(add-to-list 'lsp-language-id-configuration '(c++-mode . "cpp"))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "clangd")
                  :major-modes '(c++-mode)
                  :server-id 'clangd
                  :multi-root t)) ;; This is just so lsp-mode sends the "workspaceFolders" param to the server.
(add-hook 'c++-mode-hook #'lsp)

;; ;; d lang lsp
;; (require 'lsp-mode)
;; (add-to-list 'lsp-language-id-configuration '(d-mode . "d"))
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection "c:/Projects/serve-d/serve-d.exe")
;;                   :major-modes '(d-mode)
;;                   :server-id 'serve-d
;;                   :multi-root t))
;; (add-hook 'd-mode-hook #'lsp)

;; diminish minor modes in mode line
(require 'diminish)
(diminish 'copilot-mode)
(diminish 'undo-tree-mode)
(diminish 'company-mode)
(diminish 'yas-minor-mode)
(diminish 'smartparens-mode)
(diminish 'helm-mode)
(diminish 'projectile-mode)
(diminish 'which-key-mode)
(diminish 'lsp-mode)
(diminish 'eldoc-mode)
(diminish 'ivy-mode)


;; whitebox
;;(load-file "c:/Users/joe/whitebox-win-linux-latest/whitebox_v0.116.0/editor_plugins/emacs/whitebox.el")

;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
      (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
        "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; copilot
(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t)
(add-hook 'prog-mode-hook 'copilot-mode)

(defun rk/copilot-complete-or-accept ()
  "Command that either triggers a completion or accepts one if one
is available. Useful if you tend to hammer your keys like I do."
  (interactive)
  (if (copilot--overlay-visible)
      (progn
        (copilot-accept-completion))
    (copilot-complete)))
(define-key global-map (kbd "M-C-<return>") #'rk/copilot-complete-or-accept)

(defun rk/copilot-quit ()
  "Run `copilot-clear-overlay' or `keyboard-quit'. If copilot is
cleared, make sure the overlay doesn't come back too soon."
  (interactive)
  (condition-case err
      (when copilot--overlay
        (lexical-let ((pre-copilot-disable-predicates copilot-disable-predicates))
          (setq copilot-disable-predicates (list (lambda () t)))
          (copilot-clear-overlay)
          (run-with-idle-timer
           1.0
           nil
           (lambda ()
             (setq copilot-disable-predicates pre-copilot-disable-predicates)))))
    (error handler)))

(advice-add 'keyboard-quit :before #'rk/copilot-quit)

(use-package vterm
  :ensure t)
(require 'vterm)
(define-key vterm-mode-map (kbd "C-c C-v") 'vterm-yank)

(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
    (lambda ()
      (auth-source-pass-get 'secret "chatgpt/openai-key")))))
(setq chatgpt-shell-openai-key "chatgpt openai key here")
(global-set-key (kbd "C-c g") 'chatgpt-shell)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(chatgpt-shell-model-version 1)
 '(company-etags-everywhere t)
 '(company-idle-delay 0.01)
 '(company-minimum-prefix-length 1)
 '(company-selection-wrap-around t)
 '(company-tooltip-idle-delay 0.01)
 '(copilot-idle-delay 0.1)
 '(copilot-indent-warning-suppress t)
 '(cua-mode t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(helm-ag-fuzzy-match t)
 '(helm-candidate-number-limit 5000)
 '(highlight-indent-guides-method 'bitmap)
 '(indent-guide-recursive nil)
 '(ivy-height 20)
 '(ivy-wrap t)
 '(lsp-enable-indentation nil)
 '(lsp-enable-on-type-formatting nil)
 '(lsp-idle-delay 0.01)
 '(olivetti-body-width 85)
 '(olivetti-margin-width 0)
 '(package-check-signature nil)
 '(package-selected-packages
   '(just-mode helm-rg helm-ag helm-lsp counsel smex magit crux yasnippet-snippets yasnippet hide-mode-line workgroups2 olivetti org-superstar anzu doom-themes doom-modeline harpoon smartparens goto-chg helm-projectile lsp-mode move-text which-key projectile company))
 '(python-shell-interpreter "python3")
 '(tool-bar-mode nil)
 '(vterm-toggle-hide-method 'reset-window-configration)
 '(vterm-toggle-reset-window-configration-after-exit t)
 '(warning-minimum-level :error)
 '(warning-suppress-types
   '(((copilot copilot-no-mode-indent))
     (lsp-mode)
     (lsp-mode)
     (lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-blue ((t (:background "cyan" :foreground "cyan"))))
 '(highlight-indentation-current-column-face ((t (:background "black"))))
 '(lsp-inlay-hint-face ((t (:inherit font-lock-comment-face))))
 '(olivetti-fringe ((t (:inherit fringe)))))


(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package emacs
  :ensure nil
  :hook
  ((prog-mode . electric-pair-mode))
  :custom
  (major-mode-remap-alist
   '((yaml-mode . yaml-ts-mode)
     (bash-mode . bash-ts-mode)
     (js-mode . js-ts-mode)
     (typescript-mode . typescript-ts-mode)
     (json-mode . json-ts-mode)
     (css-mode . css-ts-mode)
     (python-mode . python-ts-mode))
	   (ruby-mode . ruby-ts-mode)))

(use-package rainbow-mode
  :ensure t
  :hook
  ((prog-mode css-mode html-mode emacs-lisp-mode) . rainbow-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  ((prog-mode . rainbow-delimiters-mode)
   (emacs-lisp-mode . rainbow-delimiters-mode)))

(use-package web-mode
  :ensure t
  :mode
  ("\\.erb\\'" . web-mode)
  ("\\.html\\'" . web-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2))

(use-package transient
  :ensure t)

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers
   '("Gemfile" "package.json")))

(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-c g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; AI Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eca
  :ensure t
  :bind
  (:prefix-map af/eca-map
   :prefix "C-c e"

   ;; Server / session
   ("e" . eca)
   ("q" . eca-stop)
   ("r" . eca-restart)
   ("w" . eca-workspaces)
   ("s" . eca-settings)
   ("g" . eca-open-global-config)

   ;; Chat
   ("c" . eca-chat-toggle-window)
   ("n" . eca-chat-new)
   ("l" . eca-chat-select)
   ("R" . eca-chat-rename)
   ("k" . eca-chat-reset)
   ("x" . eca-chat-clear)

   ;; Model / agent
   ("m" . eca-chat-select-model)
   ("a" . eca-chat-select-agent)
   ("A" . eca-chat-cycle-agent)

   ;; Context
   ("i" . eca-chat-add-context-to-user-prompt)
   ("I" . eca-chat-add-context-to-system-prompt)
   ("f" . eca-chat-add-filepath-to-user-prompt)
   ("d" . eca-chat-drop-context-from-system-prompt)

   ;; Prompt lifecycle
   ("RET" . eca-chat-send-prompt)
   ("p" . eca-chat-repeat-prompt)
   ("C-g" . eca-chat-stop-prompt)
   ("u" . eca-chat-clear-prompt)

   ;; Tool calls
   ("y" . eca-chat-tool-call-accept-next)
   ("Y" . eca-chat-tool-call-accept-all)
   ("N" . eca-chat-tool-call-reject-next)

   ;; Navigation / blocks
   ("[" . eca-chat-go-to-prev-user-message)
   ("]" . eca-chat-go-to-next-user-message)
   ("TAB" . eca-chat-toggle-expandable-block)
   ("+" . eca-chat-expand-all-blocks)
   ("-" . eca-chat-collapse-all-blocks)

   ;; History / persistence
   ("t" . eca-chat-timeline)
   ("S" . eca-chat-save-to-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Eglot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  :ensure nil
  :hook
  ((ruby-ts-mode . eglot-ensure)
   (ruby-mode . eglot-ensure)))

(with-eval-after-load 'eglot
 (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l d") #'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c l R") #'xref-find-references))

(use-package flymake
  :ensure t
  :bind
  (:map flymake-mode-map
        ("C-c ! l" . flymake-show-buffer-diagnostics)
        ("C-c ! n" . flymake-goto-next-error)
        ("C-c ! p" . flymake-goto-prev-error)
        ("C-c ! s" . flymake-start)
        ("C-c ! d" . flymake-show-project-diagnostics))
  :custom
  (flymake-no-changes-timeout 0.5)
  (flymake-start-on-save-buffer t))

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.2)

(use-package inf-ruby
  :ensure t
  :hook
  ((ruby-mode . inf-ruby-minor-mode)
  	 (ruby-ts-mode . inf-ruby-minor-mode))
  :custom
  (inf-ruby-console-environment "development")
  (inf-ruby-implementations
   '(("rails" . "bin/rails console")
     ("ruby" . "irb"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Rails helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun af/project-root ()
  "Return current project root."
  (if-let ((project (project-current)))
      (project-root project)
    default-directory))

(defun af/project-file-relative-name ()
  "Return current buffer file path relative to project root."
  (file-relative-name buffer-file-name (af/project-root)))

(defun af/rails-command (command)
  "Run COMMAND from project root using compile."
  (let ((default-directory (af/project-root)))
    (compile command)))

(defun af/rails-console ()
  "Open Rails console."
  (interactive)
  (let ((default-directory (af/project-root))
        (inf-ruby-default-implementation "rails"))
    (inf-ruby-console-auto)))

(defun af/rails-server ()
  "Run Rails server."
  (interactive)
  (af/rails-command "bin/rails server"))

(defun af/rails-db-migrate ()
  "Run Rails database migrations."
  (interactive)
  (af/rails-command "bin/rails db:migrate"))

(defun af/rails-db-migrate-with-data ()
  "Run Rails database migrations with data."
  (interactive)
	(af/rails-command "bin/rails db:migrate:with_data"))

(defun af/rails-routes ()
  "Show Rails routes."
  (interactive)
  (af/rails-command "bin/rails routes"))

(defun af/rails-test-file ()
  "Run current Rails test file."
  (interactive)
  (af/rails-command
   (format "bin/rails test %s"
           (shell-quote-argument (af/project-file-relative-name)))))

(defun af/rails-test-line ()
  "Run Rails test at current line."
  (interactive)
  (af/rails-command
   (format "bin/rails test %s:%d"
           (shell-quote-argument (af/project-file-relative-name))
           (line-number-at-pos))))

(defun af/rubocop-file ()
  "Run RuboCop on current file."
  (interactive)
  (af/rails-command
   (format "bundle exec rubocop %s"
           (shell-quote-argument (af/project-file-relative-name)))))

(defun af/rubocop-autocorrect-file ()
  "Run RuboCop autocorrect on current file."
  (interactive)
  (af/rails-command
   (format "bundle exec rubocop -A %s"
           (shell-quote-argument (af/project-file-relative-name)))))


(transient-define-prefix af/rails-menu ()
  "Rails commands."
  [["Rails"
    ("c" "console" af/rails-console)
    ("s" "server" af/rails-server)
    ("m" "db:migrate" af/rails-db-migrate)
    ("r" "routes" af/rails-routes)]

   ["Tests"
    ("f" "test file" af/rails-test-file)
    ("l" "test line" af/rails-test-line)]

   ["RuboCop"
    ("o" "check file" af/rubocop-file)
    ("a" "autocorrect file" af/rubocop-autocorrect-file)]])

(global-set-key (kbd "C-c r") #'af/rails-menu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Quality of life
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq compilation-scroll-output t)
(fset 'yes-or-no-p 'y-or-n-p)
(repeat-mode 1)

(provide 'dev)

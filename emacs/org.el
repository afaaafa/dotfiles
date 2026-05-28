(defun my/org-font-setup ()
  "Theme-aware Org heading styling."

  (let* ((heading-font
          (cond
           ((member "JetBrains Mono" (font-family-list))
            "JetBrains Mono")
           ((member "Inter" (font-family-list))
            "Inter")
           (t nil))))

    (custom-theme-set-faces
     'user

     `(org-document-title
       ((t (:inherit (default bold font-lock-keyword-face)
            ,@(when heading-font `(:family ,heading-font))
            :height 1.5
            :underline nil))))

     `(org-level-1
       ((t (:inherit (outline-1 bold)
            ,@(when heading-font `(:family ,heading-font))
            :height 1.35))))

     `(org-level-2
       ((t (:inherit (outline-2 bold)
            ,@(when heading-font `(:family ,heading-font))
            :height 1.22))))

     `(org-level-3
       ((t (:inherit (outline-3 bold)
            ,@(when heading-font `(:family ,heading-font))
            :height 1.12))))

     `(org-level-4
       ((t (:inherit (outline-4 bold)
            ,@(when heading-font `(:family ,heading-font))
            :height 1.06))))

     `(org-level-5
       ((t (:inherit (outline-5 bold)
            ,@(when heading-font `(:family ,heading-font))))))

     `(org-level-6
       ((t (:inherit (outline-6 bold)
            ,@(when heading-font `(:family ,heading-font))))))

     `(org-level-7
       ((t (:inherit (outline-7 bold)
            ,@(when heading-font `(:family ,heading-font))))))

     `(org-level-8
       ((t (:inherit (outline-8 bold)
            ,@(when heading-font `(:family ,heading-font))))))

     `(org-block
       ((t (:inherit fixed-pitch))))

     `(org-code
       ((t (:inherit fixed-pitch))))

     `(org-table
       ((t (:inherit fixed-pitch))))

     `(org-verbatim
       ((t (:inherit fixed-pitch)))))))

(add-hook 'org-mode-hook #'my/org-font-setup)

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
                        '(("^ +\\([-*]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(use-package org-bullets
   :ensure t
       :init
       (add-hook 'org-mode-hook (lambda ()
																 (org-bullets-mode 1))))
;; Agenda variables
(setq org-directory "~/org/")           ; Non-absolute paths for agenda and
                                        ; capture templates will look here.

(setq org-agenda-files '("inbox.org" "calendar.org" "work.org"))
(global-set-key (kbd "C-c C-a") #'org-agenda)

;; Default tags
(setq org-tag-alist '(
                      ;; locale
                      (:startgroup)
                      ("home" . ?h)
                      ("work" . ?w)
                      ("school" . ?s)
                      (:endgroup)
                      (:newline)
                      ;; scale
                      (:startgroup)
                      ("one-shot" . ?o)
                      ("project" . ?j)
                      ("tiny" . ?t)
                      (:endgroup)
                      ;; misc
                      ("meta")
                      ("review")
                      ("reading")))

(setq org-refile-targets
    '(("calendar.org" :maxlevel . 2)
      ("done.org" :level . 1)))

;;; Org Roam
(use-package org-roam
	:ensure t
	:custom
	(org-roam-db-autosync-mode))

;; Org-roam variables
(setq org-roam-directory "~/org-roam/")
(setq org-roam-index-file "~/org-roam/index.org")

;;; Optional variables

;; Advanced: Custom link types
;; This example is for linking a person's 7-character ID to their page on the
;; free genealogy website Family Search.
(setq org-link-abbrev-alist
      '(("family_search" . "https://www.familysearch.org/tree/person/details/%s")))

(use-package org
  :hook ((org-mode . visual-line-mode)  ; wrap lines at word breaks
         (org-mode . flyspell-mode))    ; spell checking!

  :bind (:map global-map
              ("C-c l s" . org-store-link)          ; Mnemonic: link → store
              ("C-c l i" . org-insert-link-global)  ; Mnemonic: link → insert
							("C-c c"   . org-capture)
							("C-c w"   . org-refile))
  :config
  (require 'oc-csl)                     ; citation support
  (add-to-list 'org-export-backends 'md)

  ;; Make org-open-at-point follow file links in the same window
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

  ;; Make exporting quotes better
  (setq org-export-with-smart-quotes t)
  )

(use-package org
  :config
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "OBSOLETE(o@)")))

  ;; Refile configuration
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path 'file)

	(setq org-directory "~/org/")

	(setq org-default-notes-file
				(expand-file-name "inbox.org" org-directory))

	(setq org-capture-templates
      '(("t" "Task" entry
         (file "inbox.org")
         "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")

        ("n" "Note" entry
         (file "inbox.org")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")

        ("j" "Journal" entry
         (file+olp+datetree "journal.org")
         "* %U\n\n%?\n")

				("e" "Event" entry
			   (file "calendar.org")
				"* %^{Title}\n%^T\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")

				("E" "All day event" entry
				 (file "calendar.org")
				 "* %^{Title}\n%^t\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")

        ("d" "Deadline" entry
         (file "calendar.org")
         "* TODO %?\nDEADLINE: %^t\n:PROPERTIES:\n:CREATED: %U\n:END:\n")

        ("c" "Contact" entry
         (file "contacts.org")
         "* %^{Full name}\n:PROPERTIES:\n:EMAIL: %^{Email}\n:PHONE: %^{Phone}\n:BIRTHDAY: %^{Birthday}t\n:CREATED: %U\n:END:\n\n%?\n")))

  ;; An agenda view lets you see your TODO items filtered and
  ;; formatted in different ways. You can have multiple agenda views;
  ;; please see the org-mode documentation for more information.
(setq org-agenda-custom-commands
      '(("n" "Agenda and All Todos"
         ((agenda)
          (todo)))

        ("c" "Calendar" agenda ""
         ((org-agenda-files '("calendar.org"))))

        ("w" "Work" agenda ""
         ((org-agenda-files '("work.org")))))))


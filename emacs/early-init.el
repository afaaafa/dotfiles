;;; early-init.el --- Early initialization settings -*- lexical-binding: t; -*-

;;; Commentary:
;; Performance tweaks and UI adjustments that need to run before
;; the main init.el and graphical interface are loaded.

;;; Code:

;; Performance: Increase Garbage Collector threshold for faster startup
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration: full screen and clean UI
(setq frame-resize-pixelwise t)
(tool-bar-mode -1)
(setq default-frame-alist '((fullscreen . maximized)
                            (background-color . "#000000")
                            (foreground-color . "#ffffff")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))

(provide 'early-init)
;;; early-init.el ends here

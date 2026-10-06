;; -*- lexical-binding: t; -*-

(load-theme 'modus-vivendi t)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 180)

;; Visuals
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Font Configuration
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 180)

;; Load built-in dark theme
(load-theme 'modus-vivendi t)

;; File clutter management (Move # and ~ files out of sight)
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save" user-emacs-directory) t)))
(setq create-lockfiles nil)

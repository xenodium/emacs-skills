;;; agent-send-to-emacs.el --- Send agent output to an Emacs buffer -*- lexical-binding: t; -*-

;;; Commentary:
;; Loaded by the send-to-emacs agent skill via emacsclient. Provides
;; `agent-send-to-emacs' for placing content into a named buffer in
;; the running Emacs session.

;;; Code:

(cl-defun agent-send-to-emacs (&optional &key (buffer "*agent-output*") (mode 'markdown-mode) content)
  "Create or reuse BUFFER-NAME, insert LINES joined by newlines, and display it.
BUFFER-NAME should include surrounding asterisks, e.g. \"*my-output*\".
Each element of LINES is a string; they are joined with newline separators.
The buffer is made read-only after insertion and point is left at the top."
  (let ((buf (get-buffer-create buffer)))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (when (functionp mode) (funcall mode))
      (erase-buffer)
      (insert (or (when (stringp) content)
		  (string-join lines, "\n")))
      (setq buffer-read-only t)
      (goto-char (point-min)))
    (display-buffer buf)))

(provide 'agent-send-to-emacs)
;;; agent-send-to-emacs.el ends here

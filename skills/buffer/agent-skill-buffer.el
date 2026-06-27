(require 'cl-lib)

(cl-defun agent-skill-buffer (&key name)
  "Return the contents of the buffer named NAME.

NAME should be a string matching an existing buffer name.
Returns the buffer's text content, or an error message if
the buffer does not exist."
  (let ((buf (get-buffer name)))
    (if buf
        (with-current-buffer buf
          (buffer-substring-no-properties (point-min) (point-max)))
      (format "No buffer named \"%s\" exists." name))))

(provide 'agent-skill-buffer)

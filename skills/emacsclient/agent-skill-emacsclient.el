(require 'cl-lib)

(cl-defun agent-skill-emacsclient-list-functions (&key prefix)
  "Return a list of interactive function names matching PREFIX."
  (let (result)
    (mapatoms
     (lambda (sym)
       (when (and (fboundp sym)
                  (commandp sym)
                  (string-prefix-p prefix (symbol-name sym)))
         (push (symbol-name sym) result))))
    (sort result #'string<)))

(cl-defun agent-skill-emacsclient-describe-function (&key name)
  "Return the docstring and argument list for function NAME."
  (let ((sym (intern-soft name)))
    (unless (and sym (fboundp sym))
      (error "Function %s is not defined" name))
    (let ((arglist (help-function-arglist sym t))
          (docstring (documentation sym t)))
      (format "(%s %s)\n\n%s"
              name
              (if arglist (mapconcat #'symbol-name arglist " ") "")
              (or docstring "No documentation available.")))))

(cl-defun agent-skill-emacsclient-eval-expression (&key expr)
  "Evaluate EXPR (a string) and return the result as a string."
  (format "%S" (eval (car (read-from-string expr)) t)))

(cl-defun agent-skill-emacsclient-execute-keys (&key keys)
  "Execute KEYS as if typed by the user.
KEYS is a string in `kbd' format (e.g. \"C-x C-s\", \"S c c\")."
  (execute-kbd-macro (kbd keys))
  (format "Executed: %s" keys))

(cl-defun agent-skill-emacsclient-minibuffer-prompt ()
  "Return the current minibuffer prompt and contents, or nil if inactive."
  (if (minibufferp (window-buffer (minibuffer-window)))
      (with-current-buffer (window-buffer (minibuffer-window))
        (let ((prompt (minibuffer-prompt))
              (contents (minibuffer-contents)))
          (format "Prompt: %s\nContents: %s" (or prompt "") contents)))
    "Minibuffer is not active."))

(cl-defun agent-skill-emacsclient-current-buffer-state ()
  "Return the name, major mode, and first few lines of the user's focused buffer."
  (let ((buf (window-buffer (selected-window))))
    (with-current-buffer buf
      (let ((name (buffer-name))
            (mode (symbol-name major-mode))
            (point (point))
            (excerpt (buffer-substring-no-properties
                      (point-min)
                      (min (point-max) (+ (point-min) 2000)))))
        (format "Buffer: %s\nMode: %s\nPoint: %d\n---\n%s" name mode point excerpt)))))

(provide 'agent-skill-emacsclient)

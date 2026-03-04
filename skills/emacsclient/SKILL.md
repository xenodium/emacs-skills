---
name: emacsclient
description: 'Use this skill proactively for any Emacs-related task: exploring Emacs configuration, debugging issues, testing packages, or interacting with a running Emacs instance. Capabilities: list/describe elisp functions, evaluate expressions, simulate keystrokes, inspect buffer/minibuffer state via emacsclient.'
tools: Bash
---

# Emacs Operations

The user has an Emacs server running. **All** Emacs operations must go through `emacsclient`, never `emacs` or `emacs --batch`. This includes both user-requested actions and agent-initiated operations like byte compilation, syntax checking, or running tests.

Interact with the running Emacs instance using `emacsclient --eval`. Supports six operations:

- **List functions**: Return interactive command names matching a prefix.
- **Describe function**: Return the arglist and docstring of a function.
- **Eval expression**: Evaluate an arbitrary elisp expression and return the result.
- **Execute keys**: Simulate keystrokes as if typed by the user.
- **Minibuffer prompt**: Read the current minibuffer prompt and contents (useful for seeing what Emacs is asking).
- **Current buffer state**: Return the name, major mode, and excerpt of the focused buffer.

## Basic emacsclient usage

- Open a file: `emacsclient --no-wait "/path/to/file"`
- Open at a line: `emacsclient --no-wait +42 "/path/to/file"`
- Evaluate elisp: `emacsclient --eval '(some-function)'`
- Byte compile a file:
  ```sh
  emacsclient --eval '
  (byte-compile-file "/path/to/file.el")'
  ```
- Check parentheses:
  ```sh
  emacsclient --eval '
  (with-temp-buffer
    (insert-file-contents "/path/to/file.el")
    (check-parens))'
  ```
- Run ERT tests:
  ```sh
  emacsclient --eval '
  (progn
    (load "/path/to/test-file.el" nil t)
    (ert-run-tests-batch-and-exit "pattern"))'
  ```

## Skill functions

Locate `agent-skill-emacsclient.el` which lives alongside this skill file, then call the appropriate function.

### List all elisp functions matching a prefix

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-list-functions :prefix "PREFIX"))'
```

### Describe an elisp function

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-describe-function :name "FUNCTION-NAME"))'
```

### Evaluate an elisp expression

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-eval-expression :expr "EXPRESSION"))'
```

### Execute keystrokes

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-execute-keys :keys "KEYS"))'
```

KEYS uses `kbd` format (e.g. `C-x C-s` to save, `S c c` for magit stage-all then commit).

### Read minibuffer prompt

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-minibuffer-prompt))'
```

### Read current buffer state

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/emacsclient/agent-skill-emacsclient.el" nil t)
  (agent-skill-emacsclient-current-buffer-state))'
```

## Rules

- Always use `emacsclient`, never `emacs` or `emacs --batch`.
- Use `--no-wait` when opening files so the command returns immediately.
- Use `--eval` when evaluating elisp.
- Always format `--eval` elisp across multiple lines with proper indentation.
- Locate `agent-skill-emacsclient.el` relative to this skill file's directory.
- Determine the user's intent:
  - To find functions → call `agent-skill-emacsclient-list-functions` with a `:prefix` string.
  - To inspect a function → call `agent-skill-emacsclient-describe-function` with the function `:name`.
  - To evaluate elisp → call `agent-skill-emacsclient-eval-expression` with the expression `:expr` string.
  - To simulate keystrokes → call `agent-skill-emacsclient-execute-keys` with a `kbd`-format `:keys` string.
  - To check what Emacs is prompting for → call `agent-skill-emacsclient-minibuffer-prompt`.
  - To see the focused buffer → call `agent-skill-emacsclient-current-buffer-state`.
- When driving interactive commands, use `agent-skill-emacsclient-minibuffer-prompt` and `agent-skill-emacsclient-current-buffer-state` to observe Emacs state between `agent-skill-emacsclient-execute-keys` calls.
- Note that `agent-skill-emacsclient-execute-keys` runs synchronously — if a command is async (e.g. magit refresh), a subsequent `agent-skill-emacsclient-execute-keys` call may need to be a separate `emacsclient` invocation.
- If the user's request is ambiguous, ask for clarification.
- Run `emacsclient` commands via the Bash tool.
- Present the result to the user in a readable format.

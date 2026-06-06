---
name: send-to-emacs
description: |
  Send output, text, or data to a named buffer in the running Emacs session.
  Use when the user wants to view content in Emacs rather than in the terminal.
tools: Bash
triggers:
  - "send to emacs"
  - "open in emacs"
  - "show in emacs"
  - "display in emacs"
  - "put in emacs buffer"
  - "save to emacs buffer"
  - "create emacs buffer"
  - "send output to buffer"
  - "open a buffer"
  - "show in buffer"
  - "write to emacs"
  - "view in emacs"
---

# Send output to an Emacs buffer

Send the output of the most recent command, result, or content to a new buffer in the
running Emacs session via `emacsclient --eval`.

## How to send

1. Determine the content to send: the most recent command output, generated text, file
   contents, or whatever the user indicated.
2. Choose a descriptive buffer name with asterisks (e.g. `*ctx-stats*`, `*git-log*`,
   `*build-output*`). Use the user's name if they supplied one.
3. Locate `agent-send-to-emacs.el`, which lives alongside this file at
   `skills/send-to-emacs/agent-send-to-emacs.el` in the skill directory.
4. Escape the content string for Emacs Lisp: double-quotes → `\"`, backslashes → `\\`,
   newlines → `\n`.
5. Invoke via `emacsclient --eval`. Pass each line (or logical section) as a separate
   string argument after the buffer name — they are joined with newlines:

```sh
emacsclient --eval '
(progn
  (require (quote agent-send-to-emacs)
           "/path/to/skills/send-to-emacs/agent-send-to-emacs.el")
  (agent-send-to-emacs
   :buffer "*buffer-name*"
   :mode 'markdown-mode
   :content '("first line"
              "second line"
              "third line"))'
```

   Or pass the entire content as a single pre-formatted string with embedded `\n`:

```sh
emacsclient --eval '
(progn
  (require (quote agent-send-to-emacs)
           "/path/to/skills/send-to-emacs/agent-send-to-emacs.el")
  (agent-send-to-emacs
   :buffer "*buffer-name*"
   :content "line one\nline two\nline three"))'
```

## Rules

- Always use `emacsclient --eval`, never `emacs`.
- Resolve the absolute path to `agent-send-to-emacs.el` relative to this skill file.
- Use `require` (preferred) or `load` to load the helper before calling the function.
- Use a `*name*` buffer name with asterisks. This uses the keyword argument `:buffer`
- Optionally specify a major mode with the `:mode` keyword argument.
- The content of the buffer, passed with the `:content` keyword, is
  either a string, or a sequence of strings.
- Escape all `"` as `\"` and all `\` as `\\` in the content string; embed newlines as `\n`.
- If the content is very long (>200 lines), truncate it and append a note such as
  `\n\n[truncated — full output saved to /path/to/file]` if a path is available.
- Run the `emacsclient` command via the Bash tool.

## Examples

Send ctx-stats output to `*ctx-stats*`:

```sh
emacsclient --eval '
(progn
  (require (quote agent-send-to-emacs)
           "/home/tychoish/.claude/skills/send-to-emacs/agent-send-to-emacs.el")
  (agent-send-to-emacs
   :buffer "*ctx-stats*"
   :mode 'markdown-mode
   :content '("Session stats"
	        "============="
	        ""
            "Without context-mode: 2.9 MB"
            "With context-mode:   25 KB"
            "99% kept out of context")))'
```

Send git log to `*git-log*`:

```sh
emacsclient --eval '
(progn
  (require (quote agent-send-to-emacs)
           "/home/tychoish/.claude/skills/send-to-emacs/agent-send-to-emacs.el")
  (agent-send-to-emacs
   :name "*git-log*"
   :content '("abc1234 feat: add interjection design"
              "def5678 fix: transient key conflict")))'
```

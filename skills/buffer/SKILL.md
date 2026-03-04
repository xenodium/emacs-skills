---
name: buffer
description: 'Use when the user asks to read, show, or get the contents of an Emacs buffer by name.'
tools: Bash
disable-model-invocation: false
---

# Get Emacs buffer contents

Retrieve the text contents of a named Emacs buffer using `emacsclient --eval`.

First, locate `agent-skill-buffer.el` which lives alongside this skill file at `skills/buffer/agent-skill-buffer.el` in the emacs-skills plugin directory.

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/buffer/agent-skill-buffer.el" nil t)
  (agent-skill-buffer :name "*scratch*"))'
```

## Rules

- Present the returned buffer contents to the user in the conversation.
- Locate `agent-skill-buffer.el` relative to this skill file's directory.
- Run the `emacsclient --eval` command via the Bash tool.

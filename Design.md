# Affinity: Feature Design & Showcase

This document outlines the core capabilities of **Affinity**, demonstrating its evolution from a simple `cat`/`bat` replacement into a fully-fledged terminal development environment.

Below is a breakdown of every major feature, complete with mock examples of how they appear in the terminal.

---

## 1. The Core Engine: Beautiful Code Viewing

The default behavior of Affinity (`affinity view`) provides an unparalleled, aesthetic file viewing experience.

**Key Capabilities:**
- **Intelligent Syntax Highlighting**: Powered by Pygments, supporting over 300 languages.
- **VS Code Scope Guides**: Vertical indentation guides that track code blocks, making complex nesting readable.
- **Dynamic File Header**: Displays Language, Lines, Size, and Encoding automatically.
- **Smart Line Wrapping**: Long strings gracefully wrap to the next line without breaking the Unicode box boundary.

### Example Command
```bash
affinity main.py
```

### Terminal Output
```text
╭────────────────────────────────────────────────────────────────────────────╮
│ File: main.py (Language: Python | Lines: 8 | Size: 124 B | Encoding: UTF-8)│
├────┬───────────────────────────────────────────────────────────────────────┤
│  1 │ def calculate_fibonacci(n: int) -> int:                               │
│  2 │ │   """Returns the nth Fibonacci number."""                           │
│  3 │ │   if n <= 1:                                                        │
│  4 │ │   │   return n                                                      │
│  5 │ │   return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)        │
│  6 │                                                                       │
│  7 │ if __name__ == "__main__":                                            │
│  8 │ │   print(calculate_fibonacci(10))                                    │
╰────┴───────────────────────────────────────────────────────────────────────╯
```

---

## 2. Interactive File Watcher (`watch`)

Stop running the same command repeatedly. The `watch` mode monitors a file for changes and instantly re-renders the UI the millisecond you hit save in your editor.

### Example Command
```bash
affinity watch api_server.js
```

### Terminal Output
*(The terminal clears and statically displays this, flashing instantly when `api_server.js` is modified on disk)*
```text
╭────────────────────────────────────────────────────────────────────────────╮
│ File: api_server.js (Language: JS | Lines: 4 | Size: 92 B | Encoding: UTF-8)│
├────┬───────────────────────────────────────────────────────────────────────┤
│  1 │ const express = require('express');                                   │
│  2 │ const app = express();                                                │
│  3 │                                                                       │
│  4 │ app.listen(3000, () => console.log('Live!'));                         │
╰────┴───────────────────────────────────────────────────────────────────────╯
```

---

## 3. Inline Script Execution (`run`)

Affinity can act as a mini-Jupyter notebook in your terminal. It will render the code file beautifully, execute it via the system environment, and present the `stdout` and exit codes cleanly at the bottom.

### Example Command
```bash
affinity run script.py --args "--verbose"
```

### Terminal Output
```text
╭────────────────────────────────────────────────────────────────────────────╮
│ File: script.py (Language: Python | Lines: 2 | Size: 45 B | Encoding: UTF-8)│
├────┬───────────────────────────────────────────────────────────────────────┤
│  1 │ import sys                                                            │
│  2 │ print(f"Running with args: {sys.argv}")                               │
╰────┴───────────────────────────────────────────────────────────────────────╯

Running script.py...

╭── Exit code: 0 | Time: 0.12s ──────────────────────────────────────────────╮
│ Running with args: ['script.py', '--verbose']                              │
╰────────────────────────────────────────────────────────────────────────────╯
```

---

## 4. Visual Source Diffing (`diff`)

Replaces `diff a b` with a gorgeous, color-coded unified diff viewer, analyzing what lines were added, removed, or modified between two files.

### Example Command
```bash
affinity diff old_config.json new_config.json
```

### Terminal Output
```text
╭── Diff: old_config.json -> new_config.json ────────────────────────────────╮
│ --- old_config.json                                                        │
│ +++ new_config.json                                                        │
│ @@ -1,4 +1,5 @@                                                            │
│  {                                                                         │
│ -    "theme": "dark",                                                      │
│ +    "theme": "monokai",                                                   │
│ +    "line_numbers": true,                                                 │
│      "plugins": []                                                         │
│  }                                                                         │
╰────────────────────────────────────────────────────────────────────────────╯
```
*(Lines starting with `-` are rendered in red, lines starting with `+` are rendered in green)*

---

## 5. Directory Tree Viewer

When passed a directory instead of a file, Affinity automatically transforms into an `exa`/`tree` replacement, rendering a beautiful Unicode folder hierarchy.

### Example Command
```bash
affinity src/
```

### Terminal Output
```text
📁 src/
├── 📁 components
│   ├── 📄 button.tsx
│   └── 📄 modal.tsx
├── 📁 utils
│   └── 📄 helpers.ts
└── 📄 index.ts
```

---

## 6. Standard Input (Stdin) Piping

Affinity integrates seamlessly with standard Unix pipelines. If you pipe data into it, it instantly highlights the stream.

### Example Command
```bash
cat Dockerfile | grep "RUN" | affinity
```

### Terminal Output
```text
╭────────────────────────────────────────────────────────────────────────────╮
│ File: stdin (Language: Auto | Lines: 2 | Size: 74 B | Encoding: UTF-8)    │
├────┬───────────────────────────────────────────────────────────────────────┤
│  1 │ RUN apt-get update && apt-get install -y python3                      │
│  2 │ RUN pip install -r requirements.txt                                   │
╰────┴───────────────────────────────────────────────────────────────────────╯
```

---

## 7. Targeted Line Focusing

Jump straight to the context you need by telling Affinity to highlight a specific line number.

### Example Command
```bash
affinity styles.css --line 4
```

### Terminal Output
```text
╭────────────────────────────────────────────────────────────────────────────╮
│ File: styles.css (Language: CSS | Lines: 6 | Size: 98 B | Encoding: UTF-8) │
├────┬───────────────────────────────────────────────────────────────────────┤
│  1 │ body {                                                                │
│  2 │ │   margin: 0;                                                        │
│  3 │ │   padding: 0;                                                       │
│ *4 │ │   background-color: #1e1e1e;                                        │
│  5 │ │   color: #ffffff;                                                   │
│  6 │ }                                                                     │
╰────┴───────────────────────────────────────────────────────────────────────╯
```
*(Line 4 is highlighted vividly in the terminal while surrounding lines are dimmed)*

---

## 8. Mirage Mode: Full-Screen Interactive IDE (`mirage`)

The pinnacle of Affinity is **Mirage Mode**, a full-screen, vim-inspired interactive TUI (Terminal User Interface) built with `prompt_toolkit`. It brings an integrated file browser, code editor, and secure SSH clipboard copying directly into the terminal without leaving your environment.

### Example Command
```bash
affinity mirage .
```

### Core Features of Mirage Mode

1. **Dual-Buffer Architecture**:
   - Maintains a strictly separate `RawBuffer` (holding pure file data) and a `DisplayBuffer` (handling UI elements and syntax highlighting). This ensures that when you copy code, you *only* get the code—never line numbers, guides, or box-drawing characters.

2. **Vim-Style Modality**:
   - **NORMAL Mode**: Navigate the code, jump around, or interact with the file tree. Read-only by default to prevent accidental typos.
   - **INSERT Mode** (`i`): A fully featured text editor to write code. Press `Escape` to return to Normal Mode.
   - **VISUAL Mode** (`v`): Select text precisely for copying.

3. **Secure OSC 52 Clipboard & Yanking**:
   - No more mouse-dragging across terminal panes! Press `v` to select text and `y` to yank, or `y y` to yank a single line.
   - If you are connected via SSH (detected automatically), Affinity bypasses local limitations and uses **OSC 52 escape sequences** to securely transmit the raw copied code directly to your local computer's clipboard!

4. **Interactive File Browser**:
   - A recursive, interactive left-pane file tree. Use **Up/Down** arrows to navigate and **Enter** to instantly load a file into the editor, seamlessly bypassing read-only protections. Dotfiles and backups are cleanly filtered out.

5. **Auto-Backup System**:
   - Pressing **Ctrl+S** or **q** (Quit) automatically triggers a backup. Affinity creates a `.filename.affinity.bak` copy of your file before saving the new changes, ensuring zero risk of data loss.

### Terminal Output Concept
```text
  📁 src/                     │  1 │ def main():
  ├── 📁 mirage               │  2 │     print("Hello from Mirage!")
  │   ├── 📄 app.py           │  3 │
  │   └── 📄 buffers.py       │  4 │ if __name__ == '__main__':
  └── 📄 main.py              │  5 │     main()
                              │
                              │
  NORMAL  main.py            Ln 1, Col 1                  SAVE (Ctrl+S)  QUIT (Q)
```

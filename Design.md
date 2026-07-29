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

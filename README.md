# SmartCat

> A modern replacement for `cat` and `bat` that displays source code in the terminal with VS Code-like scope guides, beautiful syntax highlighting, Unicode boxes, file information, and intelligent parsing.

SmartCat is designed to be the ultimate developer tool for reading code in the terminal, bringing the best parts of modern IDEs directly to your command line.

## Installation

```bash
pip install .
```

After installation, the `smartcat` command will be available globally.

## Features

| Feature | Description |
| :--- | :--- |
| **Beautiful Unicode Borders** | Resizes automatically according to your terminal width, drawing beautiful VS Code-esque frames around your code. |
| **Line Numbers** | Configurable line numbers, easily disabled with `--no-line-numbers`. |
| **Syntax Highlighting** | Powered by Pygments. Automatically detects languages via extension, shebang, or lexer guessing. Supports almost every programming language. |
| **VS Code Scope Guides** | (Core Feature) Intelligent vertical indentation and bracket guides that track scopes correctly for Python, C-style, and nested structures. |
| **Brace Matching** | Highlights matching and nested `()`, `[]`, and `{}` braces. |
| **Intelligent Parser** | Tracks functions, classes, loops, and conditionals using Tree-sitter or an advanced custom parser. |
| **Theme Engine** | Includes Monokai, Dracula, One Dark, Nord, Solarized, GitHub Dark, Catppuccin, and more (`--theme dracula`). |
| **Terminal Width Detection** | Wraps lines perfectly without ever cutting Unicode or breaking ANSI colors. |
| **File Information Header** | Displays the file path, language, encoding, size, and line count cleanly at the top of every file. |
| **Minimap** | A small VS Code-like minimap on the side for quickly navigating large files (`--minimap`). |
| **Folding Indicators** | Displays `▼` and `▶` beside collapsible code regions. |
| **Search Highlight** | Easily find occurrences within files (`--search term`). |
| **Highlight Current Line** | Jump right to the context you need (`--line 25`). |
| **Diff Mode** | View beautiful side-by-side file comparisons (`smartcat old.py new.py`). |
| **Directory Viewer** | View beautiful tree structures of directories, similar to `eza` (`smartcat src/`). |
| **Binary Detection** | Gracefully handles binary files instead of dumping garbage to your terminal. |
| **Nerd Font Icons** | Displays beautiful file icons (🐍, ☕, 🦀, etc.) natively in the header. |
| **High Performance** | Blazing fast rendering even for files with 100,000+ lines. |
| **Configuration File** | Customize your defaults permanently via `~/.config/smartcat/config.toml`. |

## CLI Usage

```bash
# Basic usage
smartcat file.py

# View an entire directory tree
smartcat folder/

# Use a specific theme
smartcat file.py --theme dracula

# Disable borders and formatting for plain output
smartcat file.py --plain

# View a file with search highlighting
smartcat file.py --search hello

# Highlight a specific line
smartcat file.py --line 25

# Show all options
smartcat --help
```

<div align="center">

```text
                         ___    _________________   ______________  __
                        /   |  / ____/ ____/  _/ | / /  _/_  __/\ \/ /
                       / /| | / /_  / /_   / //  |/ // /  / /    \  / 
                      / ___ |/ __/ / __/ _/ // /|  // /  / /     / /  
                     /_/  |_/_/   /_/   /___/_/ |_/___/ /_/     /_/   
```

**The ultimate, highly-aesthetic replacement for `cat` and `bat`.**

[![Python Version](https://img.shields.io/badge/python-3.8%2B-blue.svg)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Code Style: Black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

</div>

---

## 🚀 Overview

**Affinity** is a next-generation terminal tool designed for developers who want the rich viewing experience of modern IDEs (like VS Code) directly in their command line. 

Say goodbye to plain text dumps. Affinity parses your code, wraps it in beautiful Unicode borders, syntax-highlights every token flawlessly, and visually connects logical code blocks using intelligent vertical scope guides.

---

## ✨ Spectacular Features

| Feature | Description |
| :--- | :--- |
| 🎨 **VS Code Scope Guides** | Intelligent vertical indentation guides that dynamically track scopes. |
| 🌈 **Syntax Highlighting** | Real-time, hierarchical token parsing powered by Pygments. |
| 📦 **Unicode UI Frames** | Beautiful frames that seamlessly resize to your terminal width without breaking. |
| 🌲 **Directory Viewer** | Automatically renders beautiful file trees when passed a directory instead of a file. |
| 🎭 **Theme Engine** | First-class support for Monokai, Dracula, One Dark, Nord, Solarized, and more. |
| 🔍 **Search Highlighting** | Find occurrences instantly within files via the `--search` flag. |
| 🎯 **Focus Mode** | Jump straight to the context you need with `--line <num>` highlighting. |
| ⚡ **Auto-Wrapping** | Long lines gracefully wrap to the next line keeping your UI boxed flawlessly. |

---

## 💻 Installation

Affinity is officially published on PyPI and can be installed globally with a single command!

### Python Package Index (Recommended)

To install Affinity across your entire system, simply run:

```bash
pip install affinity-code-viewer
```

### Install from Source

If you prefer to install from source without messing with system environments, clone this repository and run the startup script. It bypasses environment headaches and securely installs the package exclusively for your local user.

```bash
git clone https://github.com/your-username/affinity.git
cd affinity
./start.sh
```

> **Note**: The script will automatically add `~/.local/bin` to your `PATH` if it isn't already there!

### Uninstallation

To cleanly wipe Affinity and all its artifacts from your system:

```bash
# Remove Affinity and clean up build artifacts
./remove.sh
```

---

## 🛠️ CLI Usage

Affinity was designed with an intuitive, human-first command-line interface.

```bash
# 📖 Basic File Viewing
affinity main.py

# 🌲 View an entire directory tree
affinity src/

# 🧛 Use a specific color theme
affinity main.py --theme dracula

# 🔍 Highlight search terms in the file
affinity config.yaml --search "database"

# 🎯 Highlight a specific line
affinity server.rs --line 145

# 🚫 Disable all formatting (acts like standard 'cat')
affinity data.txt --plain

# ℹ️ View all available CLI options
affinity --help
```

---

## ⚙️ Configuration

Tired of passing the `--theme` flag every time? Affinity supports permanent user configuration. 

Simply create a file at `~/.config/affinity/config.toml`:

```toml
# Default configuration
theme = "dracula"
line_numbers = true
wrap = true
scope_guides = true
```

---

## 🧬 Architecture

Affinity achieves its stunning visuals by bridging **Pygments** (for robust token lexing) and **Rich** (for terminal ANSI rendering). 

Unlike standard `bat`, Affinity intercepts the token stream and injects calculated `│` characters at precise indentation boundaries by reading mathematical spaces, ensuring that syntax colors (spans) are perfectly preserved even when slicing text arrays on the fly. 

---

## 🤝 Contributing

We welcome contributions from developers across the globe! 

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

---

## ❓ FAQ

**Q: Does Affinity support binary files?**  
A: Yes! Affinity detects binary signatures automatically and gracefully prevents terminal garbage output.

**Q: Why not just use `bat`?**  
A: `bat` is incredible, but Affinity goes a step further by natively rendering VS Code-like vertical indentation guides. This makes reading heavily nested Python or YAML files infinitely easier in the terminal.

---

<div align="center">
<i>Built with ❤️ for developers everywhere.</i>
</div>

# SmartCat

> A modern replacement for `cat` and `bat` that displays source code in the terminal with VS Code-like scope guides, beautiful syntax highlighting, Unicode boxes, file information, and intelligent parsing.

---

# Project Goal

Build a production-quality command line application called **smartcat**.

The goal is to combine the best parts of:

- cat
- bat
- VS Code
- Rich
- Pygments

into one modern terminal application.

This is **NOT** a toy project.

The code should be clean, modular, production-ready, documented and structured as if it were going to be published on GitHub with thousands of users.

---

# Technologies

Use ONLY Python.

Preferred libraries:

- rich
- pygments
- typer (CLI)
- pathlib
- tree_sitter (optional advanced parsing)
- regex
- platform
- os
- shutil
- argparse (if typer isn't used)

Do NOT use curses.

Everything should work inside a normal Ubuntu terminal.

---

# Python Version

Python >= 3.11

---

# Installation

The project should be installable using

pip install .

After installation the command

smartcat filename.py

must work from anywhere.

---

# Folder Structure

smartcat/

    smartcat/
        __init__.py
        __main__.py
        cli.py
        renderer.py
        syntax.py
        parser.py
        scope.py
        language.py
        themes.py
        config.py
        constants.py
        utils.py
        fileinfo.py
        wrapping.py
        icons.py

    tests/

    examples/

    README.md

    requirements.txt

    pyproject.toml

---

# Main Features

The project should implement ALL of these.

---------------------------------------------------------

1. Beautiful Unicode Border

Like bat.

Example

┌────────────────────────────────────────────────────────────┐
│ File: src/main.py                                         │
├────┬───────────────────────────────────────────────────────┤
│  1 │ print("Hello")                                       │
│  2 │ if True:                                             │
│  3 │ │   print("Inside")                                  │
└────┴───────────────────────────────────────────────────────┘

The border should resize automatically according to terminal width.

---

2. Line Numbers

Exactly like bat.

Configurable.

Can be disabled using

--no-line-numbers

---

3. Syntax Highlighting

Use Pygments.

Detect language automatically from

- extension
- shebang
- lexer guessing

Support

Python

Java

C

C++

C#

Go

Rust

JavaScript

TypeScript

HTML

CSS

SQL

Bash

JSON

YAML

Markdown

XML

Dockerfile

Makefile

and every language supported by Pygments.

---

4. VS Code Scope Guides

THIS IS THE MOST IMPORTANT FEATURE.

Implement vertical indentation guides exactly like VS Code.

Example

if condition:
│
├── print()

or

if():
│
│   if():
│   │
│   │   print()

Guides must continue until the matching closing scope.

For Python

Use indentation.

For C-style languages

Use

{

}

For nested structures

Draw

│

correctly.

Do NOT simply draw indentation.

Actually track scope.

---

5. Brace Matching

Detect

()

[]

{}

Highlight matching braces.

Optionally color nested braces.

---

6. Intelligent Parser

Implement a parser capable of tracking

functions

classes

loops

conditionals

match-case

switch

try

except

finally

anonymous functions

lambda

etc.

The parser should understand nesting.

Tree-sitter integration is recommended.

If tree-sitter is unavailable use a custom parser.

---

7. Theme Engine

Create

themes.py

Support

Monokai

Dracula

One Dark

Nord

Solarized Dark

GitHub Dark

Catppuccin

ANSI

The user should be able to select

smartcat file.py --theme dracula

---

8. Terminal Width Detection

Automatically detect terminal size.

Wrap lines nicely.

Never cut Unicode.

Never destroy ANSI colors.

---

9. File Information Header

Top header should contain

File name

Absolute path

Language

Encoding

Size

Number of lines

Last modified

Git status (optional)

Example

File: smartcat/parser.py

Language: Python

Lines: 382

Encoding: UTF-8

Size: 12 KB

---

10. Minimap (Optional)

Implement a small VS Code-like minimap.

Toggle

--minimap

---

11. Folding Indicators

Display

▼

▶

beside collapsible regions.

No collapsing required initially.

---

12. Search Highlight

Example

smartcat file.py --search factorial

Highlight all matches.

---

13. Highlight Current Line

Example

smartcat file.py --line 25

Highlight line 25.

---

14. Diff Mode

Support

smartcat old.py new.py

Show side-by-side diff.

---

15. Directory Viewer

If a directory is supplied

smartcat src/

Display a beautiful tree.

Like exa/eza.

---

16. Binary Detection

If binary

Show

Binary File

instead of garbage.

---

17. Unicode Support

Full Unicode support.

Never corrupt UTF-8.

---

18. Performance

Files with

100,000+

lines should still be fast.

Avoid loading unnecessary data.

---

19. CLI

Support

smartcat file.py

smartcat folder/

smartcat *.py

smartcat file.py --theme dracula

smartcat file.py --plain

smartcat file.py --no-border

smartcat file.py --wrap

smartcat file.py --line-numbers

smartcat file.py --search hello

smartcat file.py --language python

smartcat file.py --style vscode

smartcat file.py --scope

smartcat file.py --help

---

20. Configuration File

Support

~/.config/smartcat/config.toml

User preferences

theme

tab width

colors

line numbers

wrapping

border

etc.

---

21. Icons

Use Nerd Fonts when available.

Otherwise fallback.

Examples

🐍 Python

☕ Java

🦀 Rust

📄 Text

📁 Folder

---

22. Error Handling

Graceful.

Never crash.

Clear messages.

---

23. Logging

Optional debug mode.

--debug

---

24. Unit Tests

Use pytest.

Cover

parser

scope detection

themes

lexer detection

renderer

CLI

---

25. Documentation

Every module should be documented.

Every function should have type hints.

Use dataclasses where appropriate.

Follow PEP8.

---

# Rendering Pipeline

CLI

↓

Read File

↓

Detect Language

↓

Tokenize

↓

Parse Scope

↓

Generate Guides

↓

Apply Theme

↓

Wrap Lines

↓

Render Header

↓

Render Body

↓

Display

---

# Scope Algorithm

Python

Indentation stack

For each indent

push

When indent decreases

pop

Render

│

for active scopes.

C-like

Use stack

Push on {

Pop on }

Render guides accordingly.

---

# ANSI Colors

Use Rich whenever possible.

Avoid manually writing ANSI escape sequences.

---

# Coding Standards

PEP8

Type hints

Docstrings

Small reusable functions

No giant files

No duplicated code

---

# Deliverables

Claude should generate the ENTIRE project.

Do NOT generate placeholders.

Do NOT leave TODO comments.

Do NOT skip files.

Every file must be complete.

Every import must work.

The final project should be immediately installable with

pip install .

The resulting executable

smartcat

should be production-quality.

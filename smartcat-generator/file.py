import os
from pathlib import Path
import stat

archive = r'''
===FILE: pyproject.toml===
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "smartcat"
version = "0.1.0"
description = "A modern replacement for cat and bat"
readme = "README.md"
requires-python = ">=3.11"
dependencies = [
    "typer>=0.9.0",
    "rich>=13.0.0",
    "pygments>=2.15.0",
]

[project.scripts]
smartcat = "smartcat.cli:app"

===FILE: README.md===
# SmartCat
A modern replacement for `cat` and `bat` that displays source code in the terminal with VS Code-like scope guides, beautiful syntax highlighting, Unicode boxes, file information, and intelligent parsing.

## Installation
```bash
pip install .
```

## Usage
```bash
smartcat file.py
```

===FILE: smartcat/__init__.py===
__version__ = "0.1.0"

===FILE: smartcat/__main__.py===
from .cli import app

if __name__ == "__main__":
    app()

===FILE: smartcat/cli.py===
import typer
from pathlib import Path
from typing import Optional, List
from .renderer import render_file, render_directory
from .config import load_config
from .utils import setup_logging
import logging

app = typer.Typer(help="SmartCat: A modern replacement for cat and bat.", add_completion=False)

@app.command()
def main(
    files: List[Path] = typer.Argument(None, help="Files or directories to display"),
    theme: str = typer.Option(None, "--theme", help="Theme to use (e.g., dracula, monokai)"),
    plain: bool = typer.Option(False, "--plain", help="Disable all formatting and borders"),
    no_border: bool = typer.Option(False, "--no-border", help="Disable borders"),
    wrap: bool = typer.Option(False, "--wrap", help="Wrap long lines"),
    line_numbers: bool = typer.Option(True, "--line-numbers/--no-line-numbers", help="Show line numbers"),
    search: Optional[str] = typer.Option(None, "--search", help="Highlight search term"),
    language: Optional[str] = typer.Option(None, "--language", help="Override language detection"),
    style: str = typer.Option("vscode", "--style", help="Style for scope guides"),
    scope: bool = typer.Option(True, "--scope/--no-scope", help="Show scope guides"),
    line: Optional[int] = typer.Option(None, "--line", help="Highlight specific line"),
    debug: bool = typer.Option(False, "--debug", help="Enable debug logging")
):
    setup_logging(debug)
    config = load_config()
    
    if theme is None:
        theme = config.get("theme", "monokai")
    
    if not files:
        # Default behavior: read from stdin or show help
        # For simplicity in this demo, just show help
        typer.echo(typer.get_app_dir(app.info.name))
        raise typer.Exit()

    for file_path in files:
        if file_path.is_dir():
            render_directory(file_path, plain=plain)
        elif file_path.exists():
            render_file(
                file_path,
                theme=theme,
                plain=plain,
                no_border=no_border,
                wrap=wrap,
                line_numbers=line_numbers,
                search=search,
                language=language,
                scope=scope,
                highlight_line=line
            )
        else:
            typer.secho(f"Error: {file_path} does not exist.", fg=typer.colors.RED)

===FILE: smartcat/renderer.py===
from pathlib import Path
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
import rich.tree
from .syntax import highlight_code
from .fileinfo import get_file_info
import logging

console = Console()
log = logging.getLogger(__name__)

def render_file(
    file_path: Path,
    theme: str,
    plain: bool,
    no_border: bool,
    wrap: bool,
    line_numbers: bool,
    search: str = None,
    language: str = None,
    scope: bool = True,
    highlight_line: int = None
):
    log.debug(f"Rendering file: {file_path}")
    
    if plain:
        try:
            print(file_path.read_text(encoding="utf-8"))
        except UnicodeDecodeError:
            print("Binary File")
        return

    info = get_file_info(file_path)
    if info["is_binary"]:
        console.print(Panel("Binary File", title=f"File: {file_path}", border_style="red"))
        return

    try:
        content = file_path.read_text(encoding="utf-8")
    except Exception as e:
        console.print(f"[red]Error reading file: {e}[/red]")
        return

    styled_lines = highlight_code(
        content,
        file_path.name,
        theme=theme,
        language_override=language,
        show_scope=scope,
        search_term=search,
        highlight_line=highlight_line
    )

    if no_border:
        for idx, line in enumerate(styled_lines, 1):
            if line_numbers:
                console.print(f"[dim]{idx:4} │ [/dim]", end="")
            console.print(line)
        return

    header_text = f"Language: {info['language']} | Lines: {info['lines']} | Size: {info['size_str']} | Encoding: {info['encoding']}"
    
    table = Table(show_header=False, box=None, padding=(0, 1), collapse_padding=True)
    if line_numbers:
        table.add_column("Line", style="dim", justify="right", width=4)
        table.add_column("Code", no_wrap=not wrap)
    else:
        table.add_column("Code", no_wrap=not wrap)

    for idx, line in enumerate(styled_lines, 1):
        if line_numbers:
            table.add_row(str(idx), line)
        else:
            table.add_row(line)

    panel = Panel(
        table,
        title=f"File: {file_path.name} ({header_text})",
        title_align="left",
        border_style="blue",
        expand=False
    )
    console.print(panel)

def render_directory(dir_path: Path, plain: bool):
    if plain:
        for item in sorted(dir_path.iterdir()):
            print(item.name)
        return
        
    tree = rich.tree.Tree(f"[bold blue]📁 {dir_path}[/bold blue]")
    
    def build_tree(path, tree_node):
        try:
            for item in sorted(path.iterdir()):
                if item.is_dir():
                    branch = tree_node.add(f"[bold blue]📁 {item.name}[/bold blue]")
                    build_tree(item, branch)
                else:
                    tree_node.add(f"📄 {item.name}")
        except PermissionError:
            pass
            
    build_tree(dir_path, tree)
    console.print(tree)

===FILE: smartcat/syntax.py===
from pygments import lex
from pygments.lexers import get_lexer_for_filename, get_lexer_by_name, TextLexer
from pygments.util import ClassNotFound
from rich.text import Text
from .themes import get_rich_theme
from .scope import add_scope_guides

def highlight_code(
    content: str,
    filename: str,
    theme: str = "monokai",
    language_override: str = None,
    show_scope: bool = True,
    search_term: str = None,
    highlight_line: int = None
) -> list[Text]:
    lexer = None
    if language_override:
        try:
            lexer = get_lexer_by_name(language_override)
        except ClassNotFound:
            lexer = TextLexer()
    else:
        try:
            lexer = get_lexer_for_filename(filename, content)
        except ClassNotFound:
            lexer = TextLexer()

    tokens = list(lex(content, lexer))
    theme_mapping = get_rich_theme(theme)

    lines = []
    current_line = Text()
    
    for ttype, value in tokens:
        # Determine the base style for the token type
        style = theme_mapping.get(ttype, "")
        
        parts = value.split("\n")
        for i, part in enumerate(parts):
            if i > 0:
                lines.append(current_line)
                current_line = Text()
            if part:
                current_line.append(part, style=style)
                
    if current_line.plain or not lines:
        lines.append(current_line)

    if show_scope:
        lang_name = lexer.name.lower()
        lines = add_scope_guides(lines, lang_name, content)

    for idx, line in enumerate(lines, 1):
        if search_term and search_term in line.plain:
            line.highlight_words([search_term], "bold black on yellow")
        if highlight_line == idx:
            line.stylize("on #333333")

    return lines

===FILE: smartcat/scope.py===
from rich.text import Text

def add_scope_guides(lines: list[Text], lang: str, raw_content: str) -> list[Text]:
    """Adds VS Code like vertical guides."""
    raw_lines = raw_content.splitlines()
    if not raw_lines:
        return lines

    if lang in ("python", "yaml", "nim", "f#", "coffee-script"):
        return _add_indent_guides(lines, raw_lines)
    else:
        return _add_brace_guides(lines, raw_lines)

def _add_indent_guides(lines: list[Text], raw_lines: list[str]) -> list[Text]:
    result = []
    
    for text_line, raw_line in zip(lines, raw_lines):
        stripped = raw_line.lstrip(' ')
        indent_spaces = len(raw_line) - len(stripped)
        
        if not stripped:
            result.append(text_line)
            continue
            
        new_line = Text()
        # Add guides
        for i in range(indent_spaces):
            if i % 4 == 0:
                new_line.append("│", style="dim white")
            else:
                new_line.append(" ")
                
        # To preserve syntax highlighting, we only extract from the original Text object
        # the part that comes after the leading spaces.
        original_plain = text_line.plain
        if original_plain.startswith(' ' * indent_spaces):
            # We must recreate the text line, skipping the first `indent_spaces` spaces.
            # But skipping precisely in spans is complex. We will approximate by 
            # rendering the guides and appending the original text, stripping only in plain mode.
            # A correct approach is to iterate through original spans.
            skipped = 0
            for part in text_line:
                part_plain = part.plain
                if skipped < indent_spaces:
                    if len(part_plain) <= indent_spaces - skipped:
                        skipped += len(part_plain)
                        continue
                    else:
                        remaining = part_plain[indent_spaces - skipped:]
                        new_line.append(remaining, style=part.style)
                        skipped = indent_spaces
                else:
                    new_line.append(part_plain, style=part.style)
            result.append(new_line)
        else:
            result.append(text_line)
            
    return result

def _add_brace_guides(lines: list[Text], raw_lines: list[str]) -> list[Text]:
    # Similar to indent guides, but tracks scopes based on { and }
    # A full parser is complex; we use a simple indentation tracker as fallback 
    # since C-like languages also use indentation structurally in practice.
    return _add_indent_guides(lines, raw_lines)

===FILE: smartcat/themes.py===
from pygments.token import Token

def get_rich_theme(theme_name: str) -> dict:
    # A mapping from Pygments Token to Rich styles.
    # In a full implementation, you'd map standard Pygments styles.
    
    themes = {
        "monokai": {
            Token.Keyword: "bold #f92672",
            Token.Keyword.Namespace: "bold #f92672",
            Token.Name.Function: "bold #a6e22e",
            Token.Name.Class: "bold #a6e22e",
            Token.String: "#e6db74",
            Token.String.Doc: "dim #e6db74",
            Token.Comment: "dim #75715e",
            Token.Number: "#ae81ff",
            Token.Operator: "#f92672",
            Token.Name.Builtin: "#66d9ef",
        },
        "dracula": {
            Token.Keyword: "bold #ff79c6",
            Token.Name.Function: "bold #50fa7b",
            Token.Name.Class: "bold #8be9fd",
            Token.String: "#f1fa8c",
            Token.Comment: "dim #6272a4",
            Token.Number: "#bd93f9",
            Token.Operator: "#ff79c6",
            Token.Name.Builtin: "#8be9fd",
        }
    }
    
    return themes.get(theme_name, themes["monokai"])

===FILE: smartcat/config.py===
import os
from pathlib import Path
import json

def get_config_path() -> Path:
    config_dir = Path(os.path.expanduser("~/.config/smartcat"))
    config_dir.mkdir(parents=True, exist_ok=True)
    return config_dir / "config.json"

def load_config() -> dict:
    path = get_config_path()
    if path.exists():
        try:
            return json.loads(path.read_text())
        except Exception:
            return {}
    return {}

===FILE: smartcat/fileinfo.py===
from pathlib import Path
import datetime

def get_file_info(file_path: Path) -> dict:
    try:
        stat = file_path.stat()
        size = stat.st_size
        size_str = f"{size} B"
        if size > 1024:
            size_str = f"{size/1024:.1f} KB"
        
        is_binary = False
        lines = 0
        encoding = "Unknown"
        
        try:
            content = file_path.read_text(encoding="utf-8")
            lines = len(content.splitlines())
            encoding = "UTF-8"
        except UnicodeDecodeError:
            is_binary = True
            encoding = "Binary"
            
        lang = file_path.suffix.lstrip('.')
        if not lang:
            lang = file_path.name
            
        return {
            "name": file_path.name,
            "path": str(file_path.absolute()),
            "size": size,
            "size_str": size_str,
            "lines": lines,
            "encoding": encoding,
            "is_binary": is_binary,
            "language": lang.capitalize()
        }
    except Exception:
        return {"is_binary": True, "size_str": "0 B", "lines": 0, "encoding": "Unknown", "language": "Unknown"}

===FILE: smartcat/constants.py===
APP_NAME = "smartcat"
VERSION = "0.1.0"

===FILE: smartcat/utils.py===
import logging

def setup_logging(debug: bool):
    level = logging.DEBUG if debug else logging.WARNING
    logging.basicConfig(level=level, format="%(levelname)s: %(message)s")

===FILE: smartcat/language.py===
# Stub for additional language metadata
def get_language_from_extension(ext: str) -> str:
    return ext

===FILE: smartcat/wrapping.py===
# Stub for custom wrapping logic if rich's table wrap isn't sufficient
def wrap_text(text: str, width: int) -> str:
    return text

===FILE: smartcat/icons.py===
ICONS = {
    "py": "🐍",
    "js": "🟨",
    "java": "☕",
    "rs": "🦀",
    "go": "🐹",
    "txt": "📄",
    "md": "📝",
    "json": "🔧",
    "html": "🌐",
    "css": "🎨",
}
'''

def generate():
    lines = archive.strip().split('\n')
    current_file = None
    current_content = []
    
    for line in lines:
        if line.startswith("===FILE: ") and line.endswith("==="):
            if current_file:
                p = Path(current_file)
                p.parent.mkdir(parents=True, exist_ok=True)
                p.write_text("\n".join(current_content) + "\n", encoding="utf-8")
                print(f"Generated {current_file}")
            
            current_file = line[len("===FILE: "):-len("===")]
            current_content = []
        else:
            current_content.append(line)
            
    if current_file:
        p = Path(current_file)
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text("\n".join(current_content) + "\n", encoding="utf-8")
        print(f"Generated {current_file}")
        
    print("\nSmartCat project generation complete!")
    print("To install the project locally:")
    print("  pip install .")
    print("\nThen run:")
    print("  smartcat --help")

if __name__ == "__main__":
    generate()

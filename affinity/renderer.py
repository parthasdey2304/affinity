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



def build_layout(
    file_path: Path,
    styled_lines: list,
    info: dict,
    no_border: bool,
    wrap: bool,
    line_numbers: bool
):
    """Builds the rich layout for rendering."""
    if no_border:
        from rich.text import Text
        result = Text()
        for idx, line in enumerate(styled_lines, 1):
            if line_numbers:
                result.append(f"{idx:4} │ ", style="dim")
            result.append(line)
            result.append("\n")
        return result

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

    title_name = file_path.name if file_path else "stdin"
    return Panel(
        table,
        title=f"File: {title_name} ({header_text})",
        title_align="left",
        border_style="blue",
        expand=False
    )

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

    layout = build_layout(file_path, styled_lines, info, no_border, wrap, line_numbers)
    console.print(layout)

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


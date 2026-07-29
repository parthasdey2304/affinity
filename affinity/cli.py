import typer
from pathlib import Path
from typing import Optional, List
import sys
from .renderer import render_file, render_directory
from .config import load_config
from .utils import setup_logging
import logging

app = typer.Typer(help="Affinity: A modern replacement for cat and bat.", add_completion=False)

@app.command()
def view(
    files: List[Path] = typer.Argument(None, help="Files or directories to display"),
    theme: str = typer.Option(None, "--theme", help="Theme to use (e.g., dracula, monokai)"),
    plain: bool = typer.Option(False, "--plain", help="Disable all formatting and borders"),
    no_border: bool = typer.Option(False, "--no-border", help="Disable borders"),
    wrap: bool = typer.Option(True, "--wrap/--no-wrap", help="Wrap long lines"),
    line_numbers: bool = typer.Option(True, "--line-numbers/--no-line-numbers", help="Show line numbers"),
    search: Optional[str] = typer.Option(None, "--search", help="Highlight search term"),
    language: Optional[str] = typer.Option(None, "--language", help="Override language detection"),
    style: str = typer.Option("vscode", "--style", help="Style for scope guides"),
    scope: bool = typer.Option(True, "--scope/--no-scope", help="Show scope guides"),
    line: Optional[int] = typer.Option(None, "--line", help="Highlight specific line"),
    debug: bool = typer.Option(False, "--debug", help="Enable debug logging")
):
    """View a file or directory with syntax highlighting."""
    setup_logging(debug)
    config = load_config()
    
    if theme is None:
        theme = config.get("theme", "monokai")
    
    # Handle stdin
    if not sys.stdin.isatty():
        content = sys.stdin.read()
        if content:
            from .renderer import highlight_code, build_layout, console
            styled_lines = highlight_code(
                content,
                filename="stdin.txt",
                theme=theme,
                language_override=language,
                show_scope=scope,
                search_term=search,
                highlight_line=line
            )
            layout = build_layout(None, styled_lines, {"language": language or "Auto", "lines": len(content.splitlines()), "size_str": f"{len(content)} B", "encoding": "UTF-8"}, no_border, wrap, line_numbers)
            console.print(layout)
        return

    if not files:
        typer.echo("Usage: affinity [OPTIONS] [FILES]...")
        typer.echo("Try 'affinity --help' for help.")
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

@app.command()
def watch(
    file: Path = typer.Argument(..., help="File to watch"),
    theme: str = typer.Option(None, "--theme", help="Theme to use (e.g., dracula, monokai)")
):
    """Watch a file for changes and re-render in real-time."""
    config = load_config()
    theme = theme or config.get("theme", "monokai")
    
    if not file.exists() or file.is_dir():
        typer.secho("Error: Must provide a valid file path.", fg=typer.colors.RED)
        raise typer.Exit(1)
        
    try:
        from watchdog.observers import Observer
        from watchdog.events import FileSystemEventHandler
        import time
    except ImportError:
        typer.secho("Error: watchdog package not installed. Run 'pip install watchdog'.", fg=typer.colors.RED)
        raise typer.Exit(1)
        
    class WatchHandler(FileSystemEventHandler):
        def on_modified(self, event):
            if Path(event.src_path).resolve() == file.resolve():
                from rich.console import Console
                Console().clear()
                render_file(file, theme=theme, plain=False, no_border=False, wrap=True, line_numbers=True)
                
    observer = Observer()
    observer.schedule(WatchHandler(), path=str(file.parent.resolve()), recursive=False)
    observer.start()
    
    from rich.console import Console
    Console().clear()
    render_file(file, theme=theme, plain=False, no_border=False, wrap=True, line_numbers=True)
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

@app.command()
def diff(
    old_file: Path = typer.Argument(..., help="Original file"),
    new_file: Path = typer.Argument(..., help="Modified file"),
    theme: str = typer.Option(None, "--theme", help="Theme to use")
):
    """View a unified diff of two files."""
    config = load_config()
    theme = theme or config.get("theme", "monokai")
    
    if not old_file.exists() or not new_file.exists():
        typer.secho("Error: Both files must exist.", fg=typer.colors.RED)
        raise typer.Exit(1)
        
    import difflib
    old_lines = old_file.read_text(encoding="utf-8").splitlines(keepends=True)
    new_lines = new_file.read_text(encoding="utf-8").splitlines(keepends=True)
    
    diff_list = list(difflib.unified_diff(old_lines, new_lines, fromfile=old_file.name, tofile=new_file.name))
    if not diff_list:
        typer.secho("Files are identical.", fg=typer.colors.GREEN)
        return
        
    from rich.syntax import Syntax
    from rich.console import Console
    from rich.panel import Panel
    
    diff_text = "".join(diff_list)
    syntax = Syntax(diff_text, "diff", theme=theme, line_numbers=False)
    Console().print(Panel(syntax, title=f"Diff: {old_file.name} -> {new_file.name}", border_style="blue"))

@app.command()
def run(
    script: Path = typer.Argument(..., help="Python script to execute"),
    args: List[str] = typer.Argument(None, help="Arguments to pass to the script"),
    theme: str = typer.Option(None, "--theme", help="Theme to use")
):
    """View and execute a python script, showing output below."""
    if not script.exists():
        typer.secho("Error: Script must exist.", fg=typer.colors.RED)
        raise typer.Exit(1)
        
    config = load_config()
    theme = theme or config.get("theme", "monokai")
    
    from rich.console import Console
    Console().clear()
    render_file(script, theme=theme, plain=False, no_border=False, wrap=True, line_numbers=True, search=None, language="python", scope=True, highlight_line=None)
    
    import subprocess
    import time
    from rich.panel import Panel
    
    Console().print(f"\n[bold green]Running {script.name}...[/bold green]\n")
    start_time = time.time()
    
    command = ["python", str(script.resolve())]
    if args:
        command.extend(args)
        
    result = subprocess.run(command, capture_output=True, text=True)
    end_time = time.time()
    
    output = result.stdout
    if result.stderr:
        output += ("\n" if output else "") + result.stderr
        
    border_color = "green" if result.returncode == 0 else "red"
    Console().print(Panel(
        output.strip() or "[dim]No output[/dim]",
        title=f"Exit code: {result.returncode} | Time: {end_time - start_time:.2f}s",
        border_style=border_color
    ))

def main():
    # Allow `affinity file.py` to default to `affinity view file.py`
    subcommands = ["view", "watch", "diff", "run", "edit"]
    if len(sys.argv) > 1 and sys.argv[1] not in subcommands and not sys.argv[1].startswith("-"):
        sys.argv.insert(1, "view")
    app()


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


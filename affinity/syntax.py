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
        style = ""
        current_ttype = ttype
        while current_ttype is not None:
            if current_ttype in theme_mapping:
                style = theme_mapping[current_ttype]
                break
            current_ttype = current_ttype.parent
        
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


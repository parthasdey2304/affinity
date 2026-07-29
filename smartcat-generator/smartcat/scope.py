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


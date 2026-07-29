from prompt_toolkit.layout.controls import FormattedTextControl
from prompt_toolkit.layout.containers import Window, VSplit, WindowAlign
from .modes import ModeManager
from .buffers import MirageBufferSystem

def get_statusbar(mode_manager: ModeManager, buffer_system: MirageBufferSystem):
    def get_left_text():
        mode = mode_manager.get_mode_str()
        filename = buffer_system.file_path.name if buffer_system.file_path else "[No Name]"
        modified = "[+]" if buffer_system.modified else ""
        
        cursor = buffer_system.raw_buffer.document.cursor_position_row + 1
        col = buffer_system.raw_buffer.document.cursor_position_col + 1
        
        mode_color = {
            "NORMAL": "bg:ansiblue fg:ansiwhite",
            "INSERT": "bg:ansigreen fg:ansiwhite",
            "VISUAL": "bg:ansiyellow fg:ansiblack",
            "COMMAND": "bg:ansired fg:ansiwhite"
        }.get(mode, "bg:ansigray")

        return [
            (f"{mode_color} bold", f" {mode} "),
            ("bg:ansiblack fg:ansiwhite", f" {filename} {modified} "),
            ("", " "),
            ("bg:ansiblack fg:ansiwhite", f" Ln {cursor}, Col {col} ")
        ]
        
    def get_right_text():
        return [
            ("bg:ansiblack fg:ansigreen bold", " SAVE "),
            ("bg:ansiblack fg:ansiwhite", "(Ctrl+S) "),
            ("bg:ansiblack fg:ansired bold", " QUIT "),
            ("bg:ansiblack fg:ansiwhite", "(Q) ")
        ]
        
    return VSplit([
        Window(
            content=FormattedTextControl(get_left_text),
            height=1,
            style="bg:ansiblack"
        ),
        Window(
            content=FormattedTextControl(get_right_text),
            height=1,
            style="bg:ansiblack",
            align=WindowAlign.RIGHT
        )
    ])

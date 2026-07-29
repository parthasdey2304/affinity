from pathlib import Path
from prompt_toolkit import Application
from prompt_toolkit.layout import Layout
from prompt_toolkit.layout.containers import VSplit, HSplit, Window
from prompt_toolkit.layout.controls import BufferControl
from prompt_toolkit.lexers import PygmentsLexer
from pygments.lexers.python import PythonLexer
from prompt_toolkit.layout.margins import NumberedMargin

from .buffers import MirageBufferSystem
from .modes import ModeManager, MirageMode
from .filetree import FileTreeWidget
from .statusbar import get_statusbar
from .keybindings import get_keybindings

def run(start_path: Path):
    start_path = start_path.resolve()
    
    buffer_system = MirageBufferSystem()
    mode_manager = ModeManager()
    
    from prompt_toolkit.filters import Condition
    buffer_system.raw_buffer.read_only = Condition(lambda: mode_manager.current_mode != MirageMode.INSERT)
    
    root_dir = start_path if start_path.is_dir() else start_path.parent
    
    def on_file_selected(path: Path):
        buffer_system.load_file(path)
        
    file_tree = FileTreeWidget(root_dir, on_file_selected)
    
    if start_path.is_file():
        buffer_system.load_file(start_path)
            
    editor_window = Window(
        content=BufferControl(
            buffer=buffer_system.raw_buffer,
            lexer=PygmentsLexer(PythonLexer)
        ),
        left_margins=[NumberedMargin()],
        wrap_lines=True
    )
    
    body = VSplit([
        file_tree.get_window(),
        Window(width=1, char='│', style="fg:ansiblue"),
        editor_window
    ])
    
    root_container = HSplit([
        body,
        get_statusbar(mode_manager, buffer_system)
    ])
    
    layout = Layout(root_container)
    kb = get_keybindings(mode_manager, buffer_system, file_tree)
    
    app = Application(
        layout=layout,
        key_bindings=kb,
        full_screen=True,
        mouse_support=True
    )
    
    if start_path.is_file():
        layout.focus(buffer_system.raw_buffer)
    else:
        layout.focus(file_tree.get_window().content)
    
    app.run()

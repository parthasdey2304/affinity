from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.filters import Condition
from prompt_toolkit.application import get_app
from .modes import MirageMode, ModeManager
from .buffers import MirageBufferSystem
from .filetree import FileTreeWidget
from .clipboard import copy_raw
from .backup import create_backup

def get_keybindings(mode_manager: ModeManager, buffer_system: MirageBufferSystem, file_tree: FileTreeWidget):
    kb = KeyBindings()

    @kb.add('q', filter=Condition(lambda: mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        create_backup(buffer_system.file_path)
        buffer_system.save_file()
        event.app.exit()
        
    @kb.add('i', filter=Condition(lambda: mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        mode_manager.set_mode(MirageMode.INSERT)
        event.app.layout.focus(buffer_system.raw_buffer)
        
    @kb.add('v', filter=Condition(lambda: mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        mode_manager.set_mode(MirageMode.VISUAL)
        buffer_system.raw_buffer.start_selection()
        event.app.layout.focus(buffer_system.raw_buffer)
        
    @kb.add('escape', filter=Condition(lambda: mode_manager.current_mode in (MirageMode.INSERT, MirageMode.VISUAL)))
    def _(event):
        mode_manager.set_mode(MirageMode.NORMAL)
        if hasattr(buffer_system.raw_buffer, "selection_state") and buffer_system.raw_buffer.selection_state:
            buffer_system.raw_buffer.selection_state = None
        
    @kb.add('y', filter=Condition(lambda: mode_manager.current_mode == MirageMode.VISUAL))
    def _(event):
        text = buffer_system.get_selected_text()
        copy_raw(text)
        mode_manager.set_mode(MirageMode.NORMAL)
        buffer_system.raw_buffer.selection_state = None
        
    @kb.add('y', 'y', filter=Condition(lambda: mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        doc = buffer_system.raw_buffer.document
        if doc.lines:
            line = doc.lines[doc.cursor_position_row] + "\n"
            copy_raw(line)

    @kb.add('c-s')
    def _(event):
        create_backup(buffer_system.file_path)
        buffer_system.save_file()
        
    def is_tree_focused():
        return get_app().layout.has_focus(file_tree.get_window().content)

    @kb.add('down', filter=Condition(lambda: is_tree_focused() and mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        file_tree.move_cursor(1)
        
    @kb.add('up', filter=Condition(lambda: is_tree_focused() and mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        file_tree.move_cursor(-1)
        
    @kb.add('enter', filter=Condition(lambda: is_tree_focused() and mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        file_tree.toggle_expand()
        # If it's a file, auto-focus it
        if not file_tree.nodes[file_tree.selected_index][0].is_dir():
            event.app.layout.focus(buffer_system.raw_buffer)
        
    @kb.add('tab', filter=Condition(lambda: mode_manager.current_mode == MirageMode.NORMAL))
    def _(event):
        if is_tree_focused():
            event.app.layout.focus(buffer_system.raw_buffer)
        else:
            event.app.layout.focus(file_tree.get_window().content)

    return kb

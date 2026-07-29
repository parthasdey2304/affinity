import os
from pathlib import Path
from prompt_toolkit.layout.controls import FormattedTextControl
from prompt_toolkit.layout.containers import Window

class FileTreeWidget:
    def __init__(self, root_path: Path, on_file_selected=None):
        self.root_path = root_path
        self.expanded_dirs = {root_path.resolve()}
        self.on_file_selected = on_file_selected
        self.selected_index = 0
        self.nodes = [] 
        
        self.control = FormattedTextControl(
            self.get_formatted_text,
            focusable=True,
            show_cursor=False
        )
        self.window = Window(
            content=self.control,
            width=30,
            style="bg:ansiblack"
        )
        
        self.refresh()
        
    def refresh(self):
        self.nodes = []
        def traverse(path: Path, depth: int = 0):
            self.nodes.append((path, depth))
            if path.is_dir() and path.resolve() in self.expanded_dirs:
                try:
                    for child in sorted(path.iterdir(), key=lambda x: (not x.is_dir(), x.name.lower())):
                        if not child.name.startswith('.'):
                            traverse(child, depth + 1)
                except PermissionError:
                    pass
        traverse(self.root_path)
        self.selected_index = max(0, min(self.selected_index, len(self.nodes) - 1))
        
    def toggle_expand(self):
        if not self.nodes: return
        path, _ = self.nodes[self.selected_index]
        if path.is_dir():
            if path.resolve() in self.expanded_dirs:
                self.expanded_dirs.remove(path.resolve())
            else:
                self.expanded_dirs.add(path.resolve())
            self.refresh()
        else:
            if self.on_file_selected:
                self.on_file_selected(path)
                
    def move_cursor(self, offset: int):
        self.selected_index = max(0, min(self.selected_index + offset, len(self.nodes) - 1))
                
    def get_formatted_text(self):
        result = []
        for i, (path, depth) in enumerate(self.nodes):
            prefix = "  " * depth
            icon = "📁 " if path.is_dir() else "📄 "
            name = path.name or str(path)
            
            style = "reverse" if i == self.selected_index else ""
            if path.is_dir():
                if style == "reverse":
                    style = "bg:ansiwhite fg:ansiblack"
                else:
                    style = "fg:ansiblue"
                    
                if path.resolve() in self.expanded_dirs:
                    icon = "📂 "
            
            result.append((style, f"{prefix}{icon}{name}\n"))
        return result
        
    def get_window(self):
        return self.window

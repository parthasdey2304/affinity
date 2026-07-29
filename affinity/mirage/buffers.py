from prompt_toolkit.buffer import Buffer
from prompt_toolkit.document import Document
from pathlib import Path

class MirageBufferSystem:
    def __init__(self):
        self.raw_buffer = Buffer(multiline=True)
        self.file_path = None
        self.modified = False

        self.raw_buffer.on_text_changed += self._on_text_changed

    def _on_text_changed(self, _):
        self.modified = True

    def load_file(self, path: Path):
        self.file_path = path
        if path and path.exists() and not path.is_dir():
            try:
                text = path.read_text(encoding="utf-8")
                self.raw_buffer.set_document(Document(text, 0), bypass_readonly=True)
            except Exception:
                self.raw_buffer.set_document(Document("Error reading file or binary file.", 0), bypass_readonly=True)
        else:
            self.raw_buffer.set_document(Document("", 0), bypass_readonly=True)
        self.modified = False

    def save_file(self):
        if self.file_path and not self.file_path.is_dir():
            self.file_path.write_text(self.raw_buffer.text, encoding="utf-8")
            self.modified = False

    def get_raw_text(self) -> str:
        """Returns the completely unstyled, raw text."""
        return self.raw_buffer.text

    def get_selected_text(self) -> str:
        """Returns the raw selected text if in visual mode."""
        selection = self.raw_buffer.copy_selection()
        return selection.text if selection else ""

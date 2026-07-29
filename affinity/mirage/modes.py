from enum import Enum

class MirageMode(Enum):
    NORMAL = "NORMAL"
    VISUAL = "VISUAL"
    INSERT = "INSERT"
    COMMAND = "COMMAND"

class ModeManager:
    def __init__(self):
        self.current_mode = MirageMode.NORMAL

    def set_mode(self, mode: MirageMode):
        self.current_mode = mode

    def get_mode_str(self) -> str:
        return self.current_mode.value

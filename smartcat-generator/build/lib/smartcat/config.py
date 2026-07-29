import os
from pathlib import Path
import json

def get_config_path() -> Path:
    config_dir = Path(os.path.expanduser("~/.config/smartcat"))
    config_dir.mkdir(parents=True, exist_ok=True)
    return config_dir / "config.json"

def load_config() -> dict:
    path = get_config_path()
    if path.exists():
        try:
            return json.loads(path.read_text())
        except Exception:
            return {}
    return {}


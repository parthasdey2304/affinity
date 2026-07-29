from pathlib import Path
import shutil

def create_backup(file_path: Path):
    if file_path and file_path.exists() and not file_path.is_dir():
        backup_path = file_path.parent / f".{file_path.name}.affinity.bak"
        try:
            shutil.copy2(file_path, backup_path)
        except Exception:
            pass

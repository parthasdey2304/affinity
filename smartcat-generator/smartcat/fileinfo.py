from pathlib import Path
import datetime

def get_file_info(file_path: Path) -> dict:
    try:
        stat = file_path.stat()
        size = stat.st_size
        size_str = f"{size} B"
        if size > 1024:
            size_str = f"{size/1024:.1f} KB"
        
        is_binary = False
        lines = 0
        encoding = "Unknown"
        
        try:
            content = file_path.read_text(encoding="utf-8")
            lines = len(content.splitlines())
            encoding = "UTF-8"
        except UnicodeDecodeError:
            is_binary = True
            encoding = "Binary"
            
        lang = file_path.suffix.lstrip('.')
        if not lang:
            lang = file_path.name
            
        return {
            "name": file_path.name,
            "path": str(file_path.absolute()),
            "size": size,
            "size_str": size_str,
            "lines": lines,
            "encoding": encoding,
            "is_binary": is_binary,
            "language": lang.capitalize()
        }
    except Exception:
        return {"is_binary": True, "size_str": "0 B", "lines": 0, "encoding": "Unknown", "language": "Unknown"}


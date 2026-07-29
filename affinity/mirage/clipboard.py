import os
import sys
import base64
import pyperclip

def is_ssh_session() -> bool:
    return "SSH_CLIENT" in os.environ or "SSH_TTY" in os.environ

def copy_raw(text: str):
    """Copies text to clipboard cleanly using pyperclip or OSC 52 fallback."""
    if not text:
        return
        
    try:
        pyperclip.copy(text)
    except Exception:
        pass
        
    if is_ssh_session():
        # Fallback to OSC 52
        b64_text = base64.b64encode(text.encode("utf-8")).decode("utf-8")
        sys.stdout.write(f"\033]52;c;{b64_text}\007")
        sys.stdout.flush()

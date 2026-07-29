__version__ = "0.1.1"

from .renderer import render_file
from .syntax import highlight_code

__all__ = ["render_file", "highlight_code"]

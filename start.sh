#!/bin/bash

# ANSI Color Codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing Affinity...${NC}"
pip3 install --user .

# Automatically add ~/.local/bin to PATH if it isn't there
LOCAL_BIN="$HOME/.local/bin"
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo -e "${YELLOW}Adding $LOCAL_BIN to your PATH...${NC}"
    
    # Add to bashrc
    if [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    
    # Add to zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    
    # Export it for the current script execution just in case
    export PATH="$LOCAL_BIN:$PATH"
fi

echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}✓ Affinity is successfully installed and ready!${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"
echo -e ""
echo -e "${BLUE}How to use Affinity for opening code:${NC}"
echo -e "  ${YELLOW}affinity file.py${NC}              - Open a file with beautiful syntax highlighting and VS Code scope guides"
echo -e "  ${YELLOW}affinity folder/${NC}              - View a rich directory tree"
echo -e "  ${YELLOW}affinity file.py --theme dracula${NC} - Open code using the Dracula theme"
echo -e "  ${YELLOW}affinity file.py --search text${NC}   - Highlight occurrences of 'text' in the code"
echo -e "  ${YELLOW}affinity --help${NC}               - View all available commands and features"
echo -e ""
echo -e "Note: If the 'affinity' command is not found, run ${YELLOW}source ~/.bashrc${NC} or restart your terminal."

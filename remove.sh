#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Uninstalling Affinity...${NC}"
pip3 uninstall affinity -y

echo -e "${BLUE}Cleaning up local build artifacts...${NC}"
rm -rf *.egg-info build dist __pycache__

echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}✓ Affinity has been successfully removed!${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"

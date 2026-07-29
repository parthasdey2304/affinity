#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

printf "%b\n" "${BLUE}Uninstalling Affinity...${NC}"
pip3 uninstall affinity -y --break-system-packages

printf "%b\n" "${BLUE}Cleaning up local build artifacts...${NC}"
rm -rf *.egg-info build dist __pycache__

printf "%b\n" "${GREEN}------------------------------------------------${NC}"
printf "%b\n" "${GREEN}✓ Affinity has been successfully removed!${NC}"
printf "%b\n" "${GREEN}------------------------------------------------${NC}"

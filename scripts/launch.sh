#!/bin/bash
# Launch RDR2 in CrossOver bottle
# Usage: ./launch.sh

BOTTLE="RDR2-New"
GAME_PATH="C:/RDR2/Launcher.exe"

/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/bin/cxstart \
  --bottle "$BOTTLE" \
  "$GAME_PATH"
#!/bin/bash

# Default values
DAILIES_FOLDER="${HOME}/dailies"
EDITOR="nano"

# Process command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dailies)
      DAILIES_FOLDER="$2"
      shift 2
      ;;
    --file)
      FILE_TO_OPEN="$2"
      shift 2
      ;;
    --editor)
      EDITOR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Find the most recently modified file in the dailies folder (if not specified)
if [[ -z "$FILE_TO_OPEN" ]]; then
  FILE_TO_OPEN=$(ls -t "$DAILIES_FOLDER" | head -n 1)
fi

# Generate a unique session name with a timestamp
SESSION_NAME="dailies_$(date +%s)"

# Start tmux with the unique session name and send commands within the session
tmux new-session -d -s "$SESSION_NAME" \; \
  split-window -h \; \
  split-window -v \; \
  send-keys -t 0 "cd $DAILIES_FOLDER" C-m \; \
  send-keys -t 1 "$EDITOR $FILE_TO_OPEN" C-m \; \
  select-pane -t 0 \; \
  attach-session -t "$SESSION_NAME" 

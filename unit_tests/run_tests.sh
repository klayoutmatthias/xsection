#!/bin/bash -e

def_path_win="$HOME/AppData/Roaming/KLayout" 
if [ -e "$def_path_win" ] && [ -d "$def_path_win" ]; then
  echo "Adding default installation path: $def_path_win"
  export PATH="$def_path_win:$PATH"
fi

# locate klayout binary
for exe in klayout klayout_app.exe; do
  if which $exe 2>/dev/null; then
    klayout=$(which $exe)
    break
  fi
done

if [ "$klayout" = "" ]; then
  echo "No KLayout binary found in PATH .. please set path to point to klayout binary"
  exit 1
fi

echo "Using KLayout binary from: $klayout"

for test in "*.rb"; do
  "$klayout" -b -r $test
done


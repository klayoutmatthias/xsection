#!/bin/bash -e

klayout=""
exe=klayout
if which $exe >/dev/null 2>/dev/null; then
  klayout=$(which $exe)
fi

if [ "$klayout" = "" ]; then
  echo "No KLayout binary found in PATH .. please set path to point to klayout binary"
  exit 1
fi

echo "Using KLayout binary from: $klayout"

for test in *.rb; do
  "$klayout" -b -r $test
done


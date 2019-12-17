#!/bin/bash -e

export KLAYOUT_HOME=/dev/null

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

rm -rf run_dir
mkdir -p run_dir

failed=""

bin=../src/macros/xsection.lym

if [ "$1" == "" ]; then
  all_xs=( *.xs )
  tc_files=${all_xs[@]}
else
  tc_files=$*
fi

for tc_file in $tc_files; do

  tc=`echo $tc_file | sed 's/\.xs$//'` 

  echo "---------------------------------------------------"
  echo "Running testcase $tc .."

  xs_input=$(grep XS_INPUT $tc.xs | sed 's/.*XS_INPUT *= *//')
  if [ "$xs_input" = "" ]; then
    xs_input="xs_test.gds"
  fi
  xs_cut=$(grep XS_CUT $tc.xs | sed 's/.*XS_CUT *= *//')
  if [ "$xs_cut" = "" ]; then
    xs_cut="-1,0;1,0"
  fi

  $klayout -rx -z -rd xs_run=$tc.xs -rd xs_cut="$xs_cut" -rd xs_out=run_dir/$tc.gds "$xs_input" -r $bin 

  if $klayout -b -rd a=au/$tc.gds -rd b=run_dir/$tc.gds -rd tol=10 -r run_xor.rb; then
    echo "No differences found."
  else
    failed="$failed $tc"
  fi

done

echo "---------------------------------------------------"
if [ "$failed" = "" ]; then
  echo "All tests successful."
else
  echo "*** TESTS FAILED:$failed"
fi


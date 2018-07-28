#!/bin/bash -e

export KLAYOUT_HOME=/dev/null

echo "Using KLayout:"
klayout -v 
echo ""

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

  klayout -rx -z -rd xs_run=$tc.xs -rd xs_cut="$xs_cut" -rd xs_out=run_dir/$tc.gds "$xs_input" -r $bin 

  if python kdb_xor.py au/$tc.gds run_dir/$tc.gds --tol=10 -v; then
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


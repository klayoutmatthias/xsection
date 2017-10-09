#!/bin/sh -e

echo "Using KLayout:"
klayout -v 
echo ""

rm -rf run_dir
mkdir -p run_dir

failed=""

bin=../src/macros/xsection.lym

for tc_file in *.xs; do

  tc=`echo $tc_file | sed 's/\.xs$//'` 

  echo "---------------------------------------------------"
  echo "Running testcase $tc .."

  klayout -rx -z -rd xs_run=$tc.xs -rd xs_cut="-1,0;1,0" -rd xs_out=run_dir/$tc.gds xs_test.gds -r $bin 

  if klayout -b -rd a=au/$tc.gds -rd b=run_dir/$tc.gds -rd tol=10 -r run_xor.rb; then
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


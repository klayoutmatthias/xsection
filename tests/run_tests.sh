#!/bin/sh -e

for tc in xs1 xs2 xs3 xs4 xs5; do
  echo "Running testcase $tc .."
  klayout xs_test.gds -r ../src/xsection.rbm -rd xs_run=$tc.xs -rd xs_cut="-1,0;1,0" -rd xs_out="$tc.gds" -z
done



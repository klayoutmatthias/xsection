import klayout.db as kdb


class Difference(Exception):
  pass


def main(layout1, layout2, tolerance, verbose=False):
  l1 = kdb.Layout()
  l1.read(layout1)

  l2 = kdb.Layout()
  l2.read(layout2)

  # Check that same set of layers are present
  layer_pairs = []
  for ll1 in l1.layer_indices():
    li1 = l1.get_info(ll1)
    ll2 = l2.find_layer(l1.get_info(ll1))
    if ll2 is None:
      raise Difference("Layer {} of layout {} not present in layout {}.".format(li1, layout1, layout2))
    layer_pairs.append((ll1, ll2))

  for ll2 in l2.layer_indices():
    li2 = l2.get_info(ll2)
    ll1 = l1.find_layer(l2.get_info(ll2))
    if ll1 is None:
      raise Difference("Layer {} of layout {} not present in layout {}.".format(li2, layout2, layout1))

  # Check that topcell and dbu are the same
  if l1.top_cell().name != l2.top_cell().name:
    raise Difference("Top cell name of layout {} ({}) differs from that of layout {} ({}).".format(layout1, l1.top_cell().name, layout2, l2.top_cell().name))

  if (l1.dbu - l2.dbu) > 1e-6:
    raise Difference("Database unit of layout {} ({}) differs from that of layout {} ({}).".format(layout1, l1.dbu, layout2, l2.dbu))

  # Run the difftool
  diff = False
  for ll1, ll2 in layer_pairs:
    r1 = kdb.Region(l1.top_cell().begin_shapes_rec(ll1))
    r2 = kdb.Region(l2.top_cell().begin_shapes_rec(ll2))

    rxor = r1 ^ r2

    if tolerance > 0:
      rxor.size(-tolerance)

    if not rxor.is_empty():
      diff = True
      if verbose:
        print("{} differences found on layer {}.".format(rxor.size(), l1.get_info(ll1)))
    else:
      if verbose:
        print("No differences found on layer {}.".format(l1.get_info(ll1)))

  if diff:
    raise Difference("Differences found between layouts {} and {}".format(layout1, layout2))

if __name__ == "__main__":
  ''' For command line argument usage, run ``python kdb_xor.py --help``

      If there is a difference, it will return a non-zero exit code.
      Typical usage from a bash script::

          python kdb_xor.py a.gds b.gds || failed=true
          # alternatively:
          if !(python kdb_xor.py a.gds b.gds); then
            failed=true
          fi
  '''
  import sys
  import argparse
  parser = argparse.ArgumentParser(description='Run a klayout XOR to check yes/no for differences.')
  parser.add_argument('file1', help='first .gds (or .oas) file')
  parser.add_argument('file2', help='second .gds (or .oas) file')
  parser.add_argument('--tol', type=int, default=10, help='tolerance in database units (default = 10)')
  parser.add_argument('-v', '--verbose', action='store_true', help='print out status layer by layer')
  args = parser.parse_args()

  try:
    main(args.file1, args.file2, args.tol, verbose=args.verbose)
  except Difference as err:
    print(err)
    sys.exit(1)


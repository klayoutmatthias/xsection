import klayout.db as kdb


class Difference(Exception):
  pass


def main(layout1, layout2, tolerance):
  l1 = kdb.Layout()
  l1.read(layout1)

  l2 = kdb.Layout()
  l2.read(layout2)

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

  if l1.top_cell().name != l2.top_cell().name:
    raise Difference("Top cell name of layout {} ({}) differs from that of layout {} ({}).".format(layout1, l1.top_cell().name, layout2, l2.top_cell().name))

  if (l1.dbu - l2.dbu) > 1e-6:
    raise Difference("Database unit of layout {} ({}) differs from that of layout {} ({}).".format(layout1, l1.dbu, layout2, l2.dbu))

  diff = False

  for ll1, ll2 in layer_pairs:
    # import pdb; pdb.set_trace()

    r1 = kdb.Region(l1.top_cell().begin_shapes_rec(ll1))
    r2 = kdb.Region(l2.top_cell().begin_shapes_rec(ll2))

    rxor = r1 ^ r2

    if tolerance > 0:
      rxor.size(-tolerance)

    if not rxor.is_empty():
      diff = True
      print("{} differences found on layer {}.".format(rxor.size(), l1.get_info(ll1)))
    else:
      print("No differences found on layer {}.".format(l1.get_info(ll1)))

  if diff:
    raise Difference("Differences found between layouts {} and {}".format(layout1, layout2))

if __name__ == "__main__":
  global a, b, tol  # The names of the layouts, passed through command line
  # a = 'au/xs_bug4.gds'
  # b = 'run_dir/xs_bug4.gds'
  # tol = 10
  main(a, b, int(tol))



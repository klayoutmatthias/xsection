
l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

substrate = bulk

below = mask(l4).grow(0.2, :into => substrate)
atop1 = mask(l1.or(l3)).grow(0.1, 0.05, :on => below)
atop2 = mask(l1.or(l3)).grow(0.1, 0.15)

output("100/0", bulk)
output("101/0", substrate)
output("102/0", below)
output("103/0", atop1)
output("104/0", atop2)



l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

substrate = bulk

below1 = mask(l4).grow(0.05, :into => substrate)
below2 = mask(l1.or(l3)).grow(0.3, 0.2, :mode => :round, :through => below1, :into => substrate)

output("100/0", bulk)
output("101/0", substrate)
output("102/0", below1)
output("103/0", below2)


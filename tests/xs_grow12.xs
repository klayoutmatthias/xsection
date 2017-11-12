
# tests the ability to work with empty data

l1 = layer("1/0")

# Those layers don't exist
l2 = layer("12/0")
l3 = layer("13/0")
l4 = layer("14/0")

substrate = bulk

below1 = mask(l4).grow(0.05, :into => substrate)
below2 = mask(l1.or(l3)).grow(0.3, 0.2, :mode => :round, :through => below1, :into => substrate)
below3 = mask(l1.or(l3)).grow(0.3, 0.2, :into => below1)
below4 = mask(l1.or(l3)).grow(0.3, 0.2, :mode => :square, :on => below1)

output("100/0", bulk)
output("101/0", substrate)
output("102/0", below1)
output("103/0", below2)
output("104/0", below3)
output("105/0", below4)


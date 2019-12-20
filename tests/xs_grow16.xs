
# tests the ability to work with empty data

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

substrate = bulk

mask(l3).etch(0.3, :into => substrate)
mask(l4).etch(0.3, :into => substrate)

grown = mask(l2).grow(0.2, -0.15, :mode => :round)

output("100/0", bulk)
output("101/0", substrate)
output("102/0", grown)


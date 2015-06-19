
l1 = layer("1/0")

substrate = bulk

m1 = mask(l1).grow(0.3, 0.1, :mode => :round, :into => substrate, :buried => 0.4)
output("100/0", bulk)
output("101/0", substrate)
output("102/0", m1)



l1 = layer("1/0")

depth(1.0)

substrate = bulk

m1 = mask(l1).grow(0.2, :bias => -0.2, :taper => 20)

flip

mask(l1).etch(0.2, :into => substrate, :bias => -0.2, :taper => 20)

output("100/0", bulk)
output("101/0", substrate)
output("102/0", m1)


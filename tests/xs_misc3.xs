
l1 = layer("1/0")

substrate = bulk

m1 = mask(l1).grow(0.2, :bias => -0.2, :taper => 20)
etch(0.1, :into => [ substrate, m1 ])

output("100/0", bulk)
output("101/0", substrate)
output("102/0", m1)



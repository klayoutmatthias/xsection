
l1 = layer("1/0")

substrate = bulk

mask(l1.sized(0.1)).etch(0.3, :taper => 30, :into => substrate)
step1 = substrate.dup

mask(l1.inverted).etch(0.2, :into => substrate)
step2 = substrate.dup

mask(l1.inverted).etch(0.2, 0.1, :mode => :round, :into => substrate)
step3 = substrate.dup

mask(l1.inverted).etch(0.2, :into => substrate)

output("100/0", bulk)
output("101/0", step1)
output("102/0", step2)
output("103/0", step3)
output("104/0", substrate)


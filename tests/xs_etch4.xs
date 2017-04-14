
l1 = layer("1/0")

substrate = bulk

mask(l1).etch(0.3, 0.1, :taper => 20, :into => substrate)
output("100/0", bulk)
output("101/0", substrate)


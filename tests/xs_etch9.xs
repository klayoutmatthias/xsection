
l1 = layer("1/0")

substrate = bulk

m1 = mask(l1).grow(0.3, 0.3, :taper => 45)
mask(l1.sized(0.1)).etch(0.2, 0.1, :mode => :round, :into => [ m1, substrate ])

output("100/0", bulk)
output("101/0", substrate)
output("102/0", m1)


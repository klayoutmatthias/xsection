# XS_INPUT=xs_bug8.gds
# XS_CUT=-3,0;7,0

depth(20.0)
height(20.0)

l1 = layer("1/0")

substrate = bulk

m1 = deposit(1.0)
mask(l1).etch(2.0, 0.0, :into => [ m1, substrate ])
mask(l1.sized(0.2)).etch(0.0, 0.5, :into => m1)

output("1/0", substrate)
output("2/0", m1)



delta(2 * dbu)

l1 = layer("1/0")

substrate = bulk

m1 = mask(l1).grow(0.2, :taper => 5)
# simulate some air-to-material gap which must not change the behavior
m1.size(-1 * dbu, 0)
m2 = all.grow(0.2, :taper => 20, :on => m1)

output("1/0", substrate)
output("1/0", m1)
output("2/0", m2)

# tests overwrite ability
output("101/0", m1)
output("102/0", m2)

etch(0.2, :into => [ m1, m2, substrate ])

output("100/0", substrate)
output("101/0", m1)
output("102/0", m2)


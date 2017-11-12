
# Basic functionality: combine materials into new one

depth(1)

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

b = bulk

m1 = grow(0.3, 0)
m2 = mask(l1).grow(0.3, 0)

# new material built from two ones by subtracting and sizing
m1.discard   # NEEDED: m1 and m2 must be removed. Otherwise they block the etch step. MUST be there before the "and" operation.
m2.discard
m12 = m1.and(m2.sized(0.3))
m12.keep     # NEEDED: m12 is kept finally

output("100/0", b)
output("101/0", m1)
output("102/0", m2)
output("103/0", m12)

mask(l4).etch(0.1, :into => m12)
output("104/0", m12)


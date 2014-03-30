
# Basic functionality: mask data preprocessing, out-of-place operations

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

m1 = mask(l1).grow(0.05)
m2 = mask(l1.or(l3)).grow(0.05)
m3 = mask(l1.or(l3).and(l4)).grow(0.05)
m4 = mask(l2.not(l4)).grow(0.05)
m5 = mask(l1.xor(l4)).grow(0.05)
m6 = mask(l2.sized(0.1)).grow(0.05)
m7 = mask(l3.inverted).grow(0.05)

output("100/0", bulk)
output("101/0", m1)
output("102/0", m2)
output("103/0", m3)
output("104/0", m4)
output("105/0", m5)
output("106/0", m6)
output("107/0", m7)


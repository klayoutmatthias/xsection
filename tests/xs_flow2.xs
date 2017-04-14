
# Basic functionality: mask data preprocessing, in-place operations

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

m1 = mask(l1).grow(0.05)
l = l1.dup
l.add(l3)
m2 = mask(l).grow(0.05)
l.mask(l4)
m3 = mask(l).grow(0.05)
l = l2.dup
l.sub(l4)
m4 = mask(l).grow(0.05)
l = l2.dup
l.size(0.1)
m5 = mask(l).grow(0.05)
l = l3.dup
l.invert
m6 = mask(l).grow(0.05)

output("100/0", bulk)
output("101/0", m1)
output("102/0", m2)
output("103/0", m3)
output("104/0", m4)
output("105/0", m5)
output("106/0", m6)

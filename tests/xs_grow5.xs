
l1 = layer("1/0")

m1 = mask(l1).grow(0.3, :bias => -0.1, :taper => 20)
output("100/0", bulk)
output("101/0", m1)


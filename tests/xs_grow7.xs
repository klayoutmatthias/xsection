
l1 = layer("1/0")

m1 = mask(l1).grow(0.3, 0.1, :bias => 0.05, :mode => :round)
output("100/0", bulk)
output("101/0", m1)


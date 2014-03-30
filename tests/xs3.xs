
# Basic functionality: deposit

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

m1 = mask(l1).grow(0.3)
m2 = mask(l3).grow(0.3, 0.2, :mode => :round)
m3 = deposit(0.3, 0.4, :mode => :round)

output("100/0", bulk)

output("101/0", m1)
output("102/0", m2)
output("103/0", m3)

# delete all material above bulk
planarize(:into => [m1, m2, m3], :downto => bulk)

m1 = mask(l1).grow(0.3)
m2 = mask(l3).grow(0.3, 0.1, :bias => 0.05, :mode => :round)
m3 = deposit(0.3, :taper => 15)

output("111/0", m1)
output("112/0", m2)
output("113/0", m3)

# delete all material above bulk
planarize(:into => [m1, m2, m3], :downto => bulk)

m1 = mask(l1).grow(0.3)
m2 = mask(l3).grow(0.3, :taper => 10)
m3 = deposit(0.2, 0.2, :mode => :round)

output("121/0", m1)
output("122/0", m2)
output("123/0", m3)


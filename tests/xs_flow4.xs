
# Basic functionality: etch

l1 = layer("1/0")
l2 = layer("2/0")
l3 = layer("3/0")
l4 = layer("4/0")

b = bulk

mask(l1).etch(0.3, :into => b)
m1 = grow(0.3, 0.3, :mode => :round)

mask(l2).etch(0.1, :into => m1)

mask(l3).etch(0.3, 0.1, :mode => :round, :into => [ b, m1 ])

m2 = deposit(0.5)
planarize(:into => m2, :downto => m1)

mask(l3).etch(0.2, :taper => 10, :into => [ m2 ])

output("100/0", b)
output("101/0", m1)
output("102/0", m2)


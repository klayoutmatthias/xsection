# XS_INPUT=xs_bug11.gds
# XS_CUT=-10,40;60,40

depth(100)
height(100)

# Prepare input layers
layer_IN = layer("1/0")

substrate = bulk

# Grow some bars
bars = mask(layer_IN).grow(2.0)

# First epitaxial layer
epi1a = deposit(1.0, 0.1, :mode => :round)
epi1b = deposit(1.0, 0.2, :mode => :round)
epi1c = deposit(1.0, 0.3, :mode => :round)
epi1d = deposit(1.0, 0.4, :mode => :round)

# Second epitaxial layer
epi2 = deposit(3.0, 3.0, :mode => :round)

# finally output all result material to the target layout
output("1/0", substrate)
output("2/0", bars)
output("3/1", epi1a)
output("3/2", epi1b)
output("3/3", epi1c)
output("3/4", epi1d)
output("4/0", epi2)

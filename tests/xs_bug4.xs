# XS_INPUT=xs_bug4.gds
# XS_CUT=-8,16;12,16

# Prepare input layers
layer_TRENCH = layer("2/0")
layer_IMPLANT = layer("3/0")

substrate = bulk

# First epitaxial layer
epi = deposit(0.5)

# Second epitaxial layer
epi2 = deposit(0.5)

# TRENCH
# etch substrate on mask with thickness 0.7µm and angle 30°
mask(layer_TRENCH).etch(0.7, :taper => 30, :into => [substrate, epi, epi2])

# IMPLANT
# create an implant by growing the mask into the substrate material and both epitaxial layers.
implant=mask(layer_IMPLANT).grow(0.2, 0.05, :mode => :round, :into => [substrate, epi, epi2])

# finally output all result material to the target layout
output("1/0", substrate)
output("2/0", epi)
output("3/0", epi2)
output("6/0", implant)

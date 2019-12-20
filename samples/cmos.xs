
# A simple CMOS process description demonstrating:
# - Well formation
# - Field oxide formation
# - Gate formation with LDD spacers/implant 
# - W plug creating and W CMP
# - First metal layer formation

# Basic options: declare the depth of the simulation and the height.
# These are the defaults:
#   depth(2.0)
#   height(2.0)
# Declare the basic accuracy used to remove artefacts for example:
delta(5 * dbu)

# Declaration the layout layers.
# Possible operations are (l1 = layer(..); l2 = layer(..))
#   "or"     l1.or(l2)
#   "and"    l1.and(l2)
#   "xor"    l1.xor(l2)
#   "not"    l1.not(l2)
#   "size"   l1.sized(s)     (s in micron units)
#     or     l1.sized(x, y)  (x, y in micron units)
#   "invert" l1.inverted

lpoly = layer("3/0")
lactive = layer("2/0")
lfox = lactive.inverted
lwn = layer("1/0")
lcg = layer("4/0")
m1 = layer("6/0")

# Process steps:
# Now we move to cross section view: from the layout geometry we create 
# a material stack by simulating the process step by step. 
# The basic idea is that all activity happens at the surface. We can
# deposit material (over existing or at a mask), etch material and
# planarize. 
# A material is a 2D geometry as seen in the cross section along the
# measurement line.
# The following steps mimic a simple process.

# Start with the p doped bulk and assign that to material "pbulk"
# "bulk" delivers the wafer's cross section. 
pbulk = bulk

# create a n-well by growing the mask into the pbulk material. The
# pbulk material is consumed by this step. We grep 0.5 in depth and 
# 0.05 to the inside using a round approximation.
nwell = mask(lwn).grow(0.5, -0.05, :mode => :round, :into => pbulk)

# field oxide formation: we use the mask twice, once to grow upwards and 
# once to grow into the existing material. We use round approximation to 
# build a "hill", although that is not showing the typical beak. 
# Note, that we first derive the mask and use it twice. That ensures we 
# use the same seed for both contributions. Afterwards we join the 
# contributions to form the field oxide.
# "bias" will shrink the resulting area.
mfox = mask(lfox)
fox1 = mfox.grow(0.2, 0.2, :bias => 0.1, :mode => :round)

fox2 = mfox.grow(0.2, 0.2, :bias => 0.1, :mode => :round, :into => [pbulk, nwell])
fox = fox1.or(fox2)

# deposit 20nm gate oxide.
# "deposit" is an alias for "all.grow" where "all" is a special mask covering "everything".
gox = deposit(0.02)

# create poly and put silicide atop of that
poly = mask(lpoly).grow(0.15, -0.05, :mode => :round)
silicide = grow(0.10, :on => poly)

# implant the LDD areas. Note the "through" specification which allows to grow into the 
# pbulk/nwell even if covered by GOX (normally that would prevent).
# Also note, that "diffuse" is actually an alias for "all.grow".
pldd = diffuse(0.05, 0.02, :into => nwell, :through => gox, :bias => 0.01, :mode => :round)
nldd = diffuse(0.05, 0.02, :into => pbulk, :through => gox, :bias => 0.01, :mode => :round)

# deposit and etch the spacer. Deposition is conformal while etch is anisotropic
# (conformal: 0.05, 0.05, anisotropic: 0.05). Note that "etch" is an alias for "all.etch".
ox1 = deposit(0.05, 0.05)
etch(0.05, :into => ox1)

# implant the p+ and n+ source drain regions
pd = diffuse(0.1, -0.05, :into => [pldd, nwell], :through => gox, :mode => :round)
nd = diffuse(0.1, -0.05, :into => [nldd, pbulk], :through => gox, :mode => :round)

# remove gate oxide where not covered 
etch(0.02, :into => [gox, ox1])

# deposit isolation
iso = deposit(0.7, 0.7, :mode => :round)
output("400/0", iso) # for demonstration

# etch the gate and source/drain contacts
# "taper" will make the holes conical with a sidewall angle of 5 degree.
mask(lcg).etch(1.0, :into => iso, :taper => 4)

# fill with tungsten to form the plugs
w = deposit(0.15, 0.15)

# tungsten CMP: take off 0.45 micron measured from the top level of the
# w, iso materials from w and iso. 
# Alternative specifications are: 
#   :downto => {material(s)}   planarize down to these materials
#   :to => z                   planarize to the given z position measured from 0 (the initial wafer surface) 
planarize(:into => [w, iso], :less => 0.65)

# m1 isolation and etch, metal deposition and CMP 
iso2 = deposit(0.2)
mask(m1).etch(0.3, :into => iso2, :taper => 5)
alu1 = deposit(0.2, 0.2)
planarize(:into => [alu1], :less => 0.2)

# finally output all result material.
# output specification can be scattered throughout the script but it is 
# easier to read when put at the end.
output("nwell (300/0)", nwell)
output("fox (301/0)", fox)
output("gox (301/1)", gox)
output("poly (302/0)", poly)
output("silicide (302/1)", silicide)
output("pldd (303/0)", pldd)
output("nldd (304/0)", nldd)
output("ox1 (305/0)", ox1)
output("pd (306/0)", pd)
output("nd (307/0)", nd)
output("iso (308/0)", iso)
output("w (309/0)", w)
output("iso2 (310/0)", iso2)
output("alu1 (311/0)", alu1)

layers_file("cmos.lyp")


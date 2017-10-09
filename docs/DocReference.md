# XS File Reference

This document details the functions available in XS scripts. An introduction is available as a separate document: [Introduction](DocIntro)

In XS scripts, there are basically three kind of functions and methods:

* Standalone functions which don't require an object. For example "input" and "deposit"
* Methods on original layout layers (and in some weaker sense on material data objects), i.e. "invert" or "not".
* Methods on mask data objects, i.e. "grow" and "etch".

## Functions

The following standalone functions are available:

| Function | Description |
| -------- | ----------- |
| <tt>all</tt> | A pseudo-mask, covering the whole wafer |
| <tt>below(<i>b</i>)</tt> | Configures the lower height of the processing window for backside processing (see below) |
| <tt>bulk</tt> | A pseudo-material describing the wafer body |
| <tt>delta(<i>d</i>)</tt> | Configures the accuracy parameter (see below) |
| <tt>deposit(<i>...<tt>)</tt> (synonyms: grow, diffuse) | Deposits material as a uniform sheet. Equivalent to <tt>all.grow(...<tt>)</tt>. Gives a material data object |
| <tt>depth(<i>d</i>)</tt> | Configures the depth of the processing window or the wafer thickness for backside processing (see below) |
| <tt>etch(<i>...</i>)</tt> | Uniform etching. Equivalent to <tt>all.etch(...)</tt> |
| <tt>extend(<i>x</i>)</tt> | Configures the computation margin (see below) |
| <tt>flip<i> | starts or ends backside processing |
| <tt>height(<i>h</i>)</tt> | Configures the height of the processing window (see below) |
| <tt>layer(<i>layer_spec</i>)</tt> | Fetches an input layer from the original layout. Returns a layer data object. |
| <tt>layers_file(<i>lyp_filename</i>)</tt> | Configures a .lyp layer properties file to be used on the cross-section layout |
| <tt>mask(<i>layout_data</i>)</tt> | Designates the layout_data object as a litho pattern (mask). This is the starting point for structured grow or etch operations. Gives a mask data object. |
| <tt>output(<i>layer_spec</i>, <i>material</i>)</tt> | Outputs a material object to the output layout |
| <tt>planarize(<i>...</i>)</tt> | Planarization |

### <tt>all</tt> method

This method delivers a mask data object which covers the whole wafer. It's used as seed for the global etch and grow function only.

### <tt>below</tt>, <tt>depth</tt> and <tt>height</tt> methods

The material operations a performed in a limited processing window, which extends a certain height over the wafer top surface ("height"), covers the wafer with a certain depth ("depth") and extends below the wafer for backside processing ("below" parameter). Material cannot grow outside the space above or below the wafer. Etching cannot happen deeper than "depth". For backside processing, "depth" also defines the wafer thickness.

The parameters can be modified with the respective functions. All functions accept a value in micrometer units. The default value is 2 micrometers.

### <tt>bulk</tt> method

This methods returns a material data object which represents the wafer at it's initial state. This object can be used to represent the unmodified wafer substrate and can be target of etch operations. Every call of "bulk" will return a fresh object, so the object needs to be stored in a variable for later use:

```ruby
substrate = bulk
mask(layer).etch(0.5, :into => substrate)
output("1/0", substrate)
```

### <tt>delta</tt> method

Due to limitations of the underlying processor which cannot handle infinitely thin polygons, there is an accuracy limit for the creation or modification or geometrical regions. The delta parameter will basically determine that accuracy level and in some cases, for example the sheet thickness will only be accurate to that level. In addition, healing or small gaps and slivers during the processing uses the delta value as a dimension threshold, so shapes or gaps smaller than that value cannot be produced. 

The default value of "delta" is 10 database units. To modify the value, call the "delta" function with the desired delta value in micrometer units. The minimum value recommended is 2 database unit. That implies that the accuray can be increased by using a smaller database unit for the input layout.

### <tt>deposit</tt> (<tt>grow</tt>, <tt>diffuse</tt>) method

This function will deposit material uniformely. "grow" and "diffuse" are just synomyms. It is equivalent to <tt>all.grow(...)</tt>. For a description of the parameters see the "grow" method on the mask data object.

The "deposit" function will return a material object representing the deposited material.

### <tt>etch</tt> method

This function will perform a uniform etch and is equivalent to <tt>all.etch(...)</tt>. For a description of the parameter see the "etch" function on the mask data object.

### <tt>extend</tt> method

To reduce the likelihood of missing important features, the cross section script will sample the layout in a window around the cut line. The dimensions of that window are controlled by the "extend" parameter. The window extends the specified value to the left, the right, the start and end of the cut line.

The default value is 2 micrometers. To catch all relevant input data in cases where positive sizing values larger than the extend parameter are used, increase the extend value by calling "extend" with the desired value in micrometer units.

In addition, the extend parameter determines the extension of an invisible part left and right of the cross section, which is included in the processing to reduce border effects. If deposition or etching happens with dimensions bigger than the extend value, artefacts start to appear at the borders of the simulation window. The extend value can then be increased to hide these effects.

### <tt>flip</tt> method

This function will start backside processing. After this function, modifications will be applied on the back side of the wafer. Calling flip again, will continue processing on the front side.

### <tt>layer</tt> method

The layer method fetches a layout layer and prepares a layout data object for further processing. The "layer" function expects a single string parameter which encodes the source of the layout data. 

The function understands the following variants:

* <tt>layer("17")</tt>: Layer 17, datatype 0
* <tt>layer("17/6")</tt>: Layer 17, datatype 6
* <tt>layer("METAL1")</tt>: layer "METAL1" for formats that support named layers (DXF, CIF)
* <tt>layer("METAL1 (17/0)")</tt>: hybrid specification for GDS (layer 17, datatype 0) and "METAL1" for named-layer formats like DXF and CIF.

### <tt>layers_file</tt> method

This function specifies a layer properties file which will be loaded when the cross section has been generated. This file specifies colors, fill pattern and other parameters of the display:

```ruby
layers_file("/home/matthias/xsection/lyp_files/cmos1.lyp")
```

### <tt>mask</tt> method

The "mask" function designates the given layout data object as a litho mask. It returns a mask data object which is the starting point for further "etch" or "grow" operations:

```ruby
l1 = layer("1/0")
metal = mask(l1).grow(0.3)
output("1/0", metal)
```

### <tt>output</tt> method

The "output" function will write the given material to the output layout. The function expects two parameters: an output layer specification and a material object:

```ruby
output("1/0", metal)
```

The layer specifications follow the same rules than for the "layer" function described above.

### <tt>planarize</tt> method

The "planarize" function removes material of the given kind ("into" argument) down to a certain level. The level can be determined numerically or by a stop layer.

The function takes a couple of named parameters in the Ruby notation (":name => value"), for example:

```ruby
planarize(:downto => substrate, :into => metal)
planarize(:less => 0.5, :into => [ metal, substrate ])
```

The named parameters are:

| Name | Description |
| ---- | ----------- |
| :into | (mandatory) A single material or an array or materials. The planarization will remove these materials selectively |
| :downto | Value is a material. Planarization stops at the topmost point of that material. Cannot be used together with :less or :to. |
| :less | Value is a micrometer distance. Planarization will remove a horizontal alice of the given material, stopping "less" micrometers measured from the topmost point of that material before the planarization. Cannot be used together with :downto or :to. |
| :to | Value is micrometer z value. Planarization stops when reaching that value. The z value is measured from the initial wafer surface. Cannot be used together with :downto or :less. |


## Methods on original layout layers or material data objects

The following methods are available for these objects:

| Method | Description |
| ------ | ----------- |
| <tt>size(<i>s</i>)</tt> or <tt>size(<i>x</i>,<i> y</i>)</tt> | Isotropic or anisotropic sizing |
| <tt>sized(<i>s</i>)</tt> or <tt>sized(<i>x</i>,<i> y</i>)</tt> | Out-of-place version of <tt>size</tt> |
| <tt>invert</tt> | Invert a layer |
| <tt>inverted</tt> | Out-of-place version of <tt>invert</tt> |
| <tt>or(<i>other</i>)</tt> | Boolean OR (merging) with another layer |
| <tt>and(<i>other</i>)</tt> | Boolean AND (intersection) with another layer |
| <tt>xor(<i>other</i>)</tt> | Boolean XOR (symmetric difference) with another layer |
| <tt>not(<i>other</i>)</tt> | Boolean NOT (difference) with another layer |

### <tt>size</tt> method

This method will apply a bias to the layout data. A bias is applied by shifting the edges to the outside (for positive bias) or the inside (for negative bias) of the figure.

Applying a bias will increase or reduce the dimension of a figure by twice the value.

Two versions are available: isotropic or anisotropic sizing. The first version takes one sie value in micrometer units and applies this value in x and y direction. The second version takes two values for x and y direction. 

The "size" method will modify the layer object (in-place). A non-modifying version (out-of-place) is "sized".

```ruby
l1 = layer("1/0")
l1.size(0.3)
metal = mask(l1).grow(0.3)
```

### <tt>sized</tt> method

Same as "size", but returns a new layout data object rather than modifying it:

```ruby
l1 = layer("1/0")
l1_sized = l1.sized(0.3)
metal = mask(l1_sized).grow(0.3)
# l1 can still be used in the original form
```

### <tt>invert</tt> method

Inverts a layer (creates layout where nothing is drawn and vice versa). This method modifies the layout data object (in-place):

```ruby
l1 = layer("1/0")
l1.invert
metal = mask(l1).grow(0.3)
```

A non-modifying version (out-of-place) is "inverted".

### <tt>inverted</tt> method

Returns a new layout data object representing the inverted source layout:

```ruby
l1 = layer("1/0")
l1_inv = l1.inverted
metal = mask(l1_inv).grow(0.3)
# l1 can still be used in the original form
```

### <tt>or</tt>, <tt>and</tt>, <tt>xor</tt> or <tt>not</tt> methods

These methods perform boolean operations. Their notation is somewhat unusual but follows the method notation of Ruby:

```ruby
l1 = layer("1/0")
l2 = layer("2/0")
one_of_them = l1.xor(l2)
```

Here is the output of the operations:

| a     | b     | <tt>a.or(b)</tt> | <tt>a.and(b)</tt> | <tt>a.xor(b)</tt> | <tt>a.not(b)</tt> |
| ----- | ----- | ----- | ----- | ----- | ----- |
| clear | clear | clear | clear | clear | clear |
| drawn | clear | drawn | clear | drawn | drawn |
| clear | drawn | drawn | clear | drawn | clear |
| drawn | drawn | drawn | drawn | clear | clear |


## Methods on mask data objects - grow and etch

The following methods are available for mask data objects:

| Method | Description |
| ------ | ----------- |
| <tt>grow(<i>...</i>)</tt> | Deposition of material where this mask is present |
| <tt>etch(<i>...</i>)</tt> | Removal of material where this mask is present |

### <tt>grow</tt> method

This method is important and has a rich parameter set, so is is described in an individual document here: [Grow Method](DocGrow)

### <tt>etch</tt> method

This method is important and has a rich parameter set, so is is described in an individual document here: [Etch Method](DocEtch)


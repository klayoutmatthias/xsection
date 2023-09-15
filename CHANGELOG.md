
# Version 1.7 - 2023-09-15

* Bugfix for XS::layer

# Version 1.6 - 2023-09-05

* Generalizing some useful methods (XS::base_box, XS::layer)
* Ruby 2.x compatibility enhanced
* Compatibility with older KLayout versions

# Version 1.5 - 2023-08-30

* Enabling multi-rulers in 0.28.x KLayout version:
  KLayout 0.28.x features multi-rules which more than two points.
  The cross section script will ignore every second segment and stitch
  the other segments into a linear view if it encounters such a case.
  This means, you can create cross sections that are made from multiple
  parts by connecting the active parts with inactive segments of a
  multi-ruler.

# Version 1.4 - 2019-12-20

* Modification of the "taper" behavior to match with the old SourceForge
  version. The step coverage was not consistent: without horizontal extension
  (i.e. "grow(z, :taper => t)"), steps have been convered with a horizontal
  overlap creating a sidewall. Now, this case creates a "roof" without sidewalls 
  again.

* Multiple rulers can be present now and will be turned into multiple 
  cross section views. A new dedicated ruler template "XSection" is defined and
  can be picked from the "Ruler"-dropdown menu. If such a ruler is 
  present, this one will be taken and other rulers are ignored (good
  for measuring while doing XSection runs).

* Some maintenance of the geometry production algorithm with the result
  of less slivers and artefacts.

* Up to 10 entries in the list of recent files

* "output" will overwrite existing layers, so this function can be used
  multiple times (good with "snapshot" and "pause")

* New function "snapshot" or "snapshot(name)": this function will rename
  the tab if a name is present and continue in a new tab. Note: the snapshot
  will only show the outputs collected so far. New outputs will only appear
  in the new tab. The outputs will also be shown only in the current state,
  so if you use "etch/into" for example to modify a material, you'll need
  to output it again in order to show it in the new shape on the new tabs.

* New function "pause" or "pause(name)": this function will show all outputs
  collected so far and pause with a question whether to continue or not.
  If a name is given, the output tab will be renamed to this name.

* New function "dbu(d)" to change the computation accuracy. Good for achieving
  a finer resolution for the output geometry.

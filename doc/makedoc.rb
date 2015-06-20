
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

# This script produces the documentation images.
# Use makedoc.sh to run it.

def configure_view(view)

  view.set_config("grid-micron", "0.1")
  view.set_config("background-color", "#000000")
  view.set_config("grid-color", "#303030")
  view.set_config("grid-show-ruler", "true")
  view.set_config("grid-style0", "invisible")
  view.set_config("grid-style1", "light-dotted-lines")
  view.set_config("grid-style2", "light-dotted-lines")
  view.set_config("grid-visible", "true")

end

def configure_view_xs(view)

  view.set_config("grid-micron", "0.1")
  view.set_config("background-color", "#000000")
  view.set_config("grid-color", "#404040")
  view.set_config("grid-show-ruler", "true")
  view.set_config("grid-style0", "invisible")
  view.set_config("grid-style1", "invisible")
  view.set_config("grid-style2", "invisible")
  view.set_config("grid-visible", "true")

end

screenshot_width = 640
screenshot_height = 400

app = RBA::Application::instance
mw = app.main_window

# -------------------------------------------------------------------
#  Sample 1

sample = "s1"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")
l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(0, -600, 400, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Prepare input layers
m1 = layer("1/0")

# "grow" metal on mask m1 with thickness 0.3 and lateral extension 0.1
# with elliptical edge contours
metal1 = mask(m1).grow(0.3, 0.1, :mode => :round)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal1)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.15)
ant.p2 = RBA::DPoint::new(1.0, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.2)
ant.p2 = RBA::DPoint::new(0.4, 0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.2)
ant.p2 = RBA::DPoint::new(1.0, 0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.5, -0.05)
ant.p2 = RBA::DPoint::new(0.5, 0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, -0.05)
ant.p2 = RBA::DPoint::new(0.9, 0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, 0)
ant.p2 = RBA::DPoint::new(0.5, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Sample 2

sample = "s2"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")
l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-200, -600, 600, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Prepare input layers
m1 = layer("1/0").inverted

# deposit metal with width 0.25 micron
metal1 = deposit(0.25)

substrate = bulk

# etch metal on mask m1 with thickness 0.3 and lateral extension 0.1
# with elliptical edge contours
mask(m1).etch(0.3, 0.1, :mode => :round, :into => [ metal1, substrate ])

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal1)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.35)
ant.p2 = RBA::DPoint::new(1.0, 0.35)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.25)
ant.p2 = RBA::DPoint::new(1.2, -0.05)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, 0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.2)
ant.p2 = RBA::DPoint::new(1.0, 0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0)
ant.p2 = RBA::DPoint::new(0.3, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0)
ant.p2 = RBA::DPoint::new(1.1, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.2)
ant.p2 = RBA::DPoint::new(0.3, -0.2)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.25)
ant.p2 = RBA::DPoint::new(1.25, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Sample 3

sample = "s3"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-200, -600, 600, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(0, -200, 400, 200))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0").inverted
m2 = layer("2/0")

# deposit metal with width 0.25 micron
metal1 = deposit(0.25)

substrate = bulk

# etch metal on mask m1 with thickness 0.3 and lateral extension 0.1
# with elliptical edge contours
mask(m1).etch(0.3, 0.1, :mode => :round, :into => [ metal1, substrate ])

# process from the backside
flip

# backside etch, taper angle 4 degree
mask(m2).etch(1, :taper => 4, :into => substrate)

# fill with metal and polish
metal2 = deposit(0.3, 0.3, :mode => :square)
planarize(:downto => substrate, :into => metal2)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal1.or(metal2))
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -1.3, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.35)
ant.p2 = RBA::DPoint::new(1.0, 0.35)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.25)
ant.p2 = RBA::DPoint::new(1.2, -0.05)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, 0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.2)
ant.p2 = RBA::DPoint::new(1.0, 0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0)
ant.p2 = RBA::DPoint::new(0.3, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0)
ant.p2 = RBA::DPoint::new(1.1, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.2)
ant.p2 = RBA::DPoint::new(0.3, -0.2)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.25)
ant.p2 = RBA::DPoint::new(1.25, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, -0.9)
ant.p2 = RBA::DPoint::new(0.9, -1.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.5, -0.9)
ant.p2 = RBA::DPoint::new(0.5, -1.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, -1.15)
ant.p2 = RBA::DPoint::new(0.5, -1.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 1

sample = "g1"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.4)
ant.p2 = RBA::DPoint::new(0.4, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.25)
ant.p2 = RBA::DPoint::new(0.4, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.25)
ant.p2 = RBA::DPoint::new(1.0, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 2

sample = "g2"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, 0.1)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.4)
ant.p2 = RBA::DPoint::new(0.3, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0.25)
ant.p2 = RBA::DPoint::new(0.3, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.25)
ant.p2 = RBA::DPoint::new(1.1, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 3

sample = "g3"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, 0.1, :mode => :round)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.4)
ant.p2 = RBA::DPoint::new(0.3, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0.2)
ant.p2 = RBA::DPoint::new(0.3, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.2)
ant.p2 = RBA::DPoint::new(1.1, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 4

sample = "g4"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, -0.1, :mode => :round)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, 0.4)
ant.p2 = RBA::DPoint::new(0.5, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.5, 0.25)
ant.p2 = RBA::DPoint::new(0.5, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, 0.25)
ant.p2 = RBA::DPoint::new(0.9, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 5

sample = "g5"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, 0.1, :mode => :octagon)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.4)
ant.p2 = RBA::DPoint::new(0.3, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0.2)
ant.p2 = RBA::DPoint::new(0.3, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, 0.2)
ant.p2 = RBA::DPoint::new(1.1, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 6

sample = "g6"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, 0.1, :mode => :round, :bias => 0.05)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.4)
ant.p2 = RBA::DPoint::new(0.35, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.35, 0.2)
ant.p2 = RBA::DPoint::new(0.35, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.2)
ant.p2 = RBA::DPoint::new(1.05, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 7

sample = "g7"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, :taper => 10)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.95, 0.4)
ant.p2 = RBA::DPoint::new(0.45, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " 0.6 - 2 x 10°"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.45, 0.25)
ant.p2 = RBA::DPoint::new(0.45, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.95, 0.25)
ant.p2 = RBA::DPoint::new(0.95, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 8

sample = "g8"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, :taper => 10, :bias => -0.1)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.4)
ant.p2 = RBA::DPoint::new(0.35, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " 0.8 - 2 x 10°"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.35, 0.25)
ant.p2 = RBA::DPoint::new(0.35, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.25)
ant.p2 = RBA::DPoint::new(1.05, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 9 

if false # does not work as expected yet

sample = "g9"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

metal = mask(m1).grow(0.3, :taper => -10)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.4)
ant.p2 = RBA::DPoint::new(0.35, 0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " 0.8 - 2 x 10°"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.35, 0.25)
ant.p2 = RBA::DPoint::new(0.35, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.25)
ant.p2 = RBA::DPoint::new(1.05, 0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, 0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, 0.3)
ant.p2 = RBA::DPoint::new(1.25, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.05)
ant.p2 = RBA::DPoint::new(1.0, -0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

end


# -------------------------------------------------------------------
#  Doc grow sample 10

sample = "g10"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-1000, -600, 0, 600))

l3 = main_ly.layer(3, 0)
main_top.shapes(l3).insert(RBA::Box::new(600, -600, 2000, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")
m3 = layer("3/0")

substrate = bulk
mask(m2).etch(0.5, :into => substrate, :taper => 30)
mask(m3).etch(0.5, :into => substrate)

metal = mask(m1).grow(0.3, 0.1, :mode => :round)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0.2)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleArrowBoth
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0)
ant.p2 = RBA::DPoint::new(0.3, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0)
ant.p2 = RBA::DPoint::new(0.4, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.3)
ant.p2 = RBA::DPoint::new(1.3, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.3)
ant.p2 = RBA::DPoint::new(1.35, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0)
ant.p2 = RBA::DPoint::new(1.35, 0)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.65)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.15)
ant.p2 = RBA::DPoint::new(1.3, -0.65)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.6)
ant.p2 = RBA::DPoint::new(0.4, -0.6)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


if false   # does not work well

# -------------------------------------------------------------------
#  Doc grow sample 11

sample = "g11"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-1000, -600, 0, 600))

l3 = main_ly.layer(3, 0)
main_top.shapes(l3).insert(RBA::Box::new(600, -600, 2000, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")
m3 = layer("3/0")

substrate = bulk
mask(m2).etch(0.5, :into => substrate, :taper => 30)
mask(m3).etch(0.5, :into => substrate)

metal = mask(m1).grow(0.3, 0.1, :taper => 20)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0.2)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleArrowBoth
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, 0)
ant.p2 = RBA::DPoint::new(0.3, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0)
ant.p2 = RBA::DPoint::new(0.4, 0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.3)
ant.p2 = RBA::DPoint::new(1.3, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0.3)
ant.p2 = RBA::DPoint::new(1.35, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0)
ant.p2 = RBA::DPoint::new(1.35, 0)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.65)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.15)
ant.p2 = RBA::DPoint::new(1.3, -0.65)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.6)
ant.p2 = RBA::DPoint::new(0.4, -0.6)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

end

# -------------------------------------------------------------------
#  Doc grow sample 12

sample = "g12"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-200, -600, 400, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

# Grow a stop layer
stop = mask(m2).grow(0.05)

# Grow with mask m1, but only where there is a substrate surface
metal = mask(m1).grow(0.3, 0.1, :mode => :round, :on => bulk)

# output the material data to the target layout
output("0/0", bulk)
output("1/0", metal)
output("2/0", stop)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0.3)
ant.p2 = RBA::DPoint::new(1.6, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.25, 0.3)
ant.p2 = RBA::DPoint::new(1.65, 0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.15)
ant.p2 = RBA::DPoint::new(0.4, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(1.3, -0.25)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.2)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 13

sample = "g13"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

# Grow with mask m1 into the substrate
metal = mask(m1).grow(0.3, 0.1, :mode => :round, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal)

END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.3)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.25, -0.3)
ant.p2 = RBA::DPoint::new(1.65, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Doc grow sample 14

sample = "g14"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-300, -600, 400, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

stop = mask(m2).grow(0.05, :into => substrate)

# Grow with mask m1 into the substrate
metal = mask(m1).grow(0.3, 0.1, :mode => :round, :through => stop, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal)
output("2/0", stop)

END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.3)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.65, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Doc grow sample 15

sample = "g15"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

# Grow with mask m1 into the substrate
metal = mask(m1).grow(0.3, 0.1, :mode => :round, :into => substrate, :buried => 0.4)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", metal)

END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.8, 2.1, 0.3))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.25, -0.4)
ant.p2 = RBA::DPoint::new(1.65, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.5)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.5)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Doc etch sample 1

sample = "e1"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.4)
ant.p2 = RBA::DPoint::new(0.4, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.25)
ant.p2 = RBA::DPoint::new(0.4, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.25)
ant.p2 = RBA::DPoint::new(1.0, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 2

sample = "e2"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, 0.1, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.4)
ant.p2 = RBA::DPoint::new(0.3, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, -0.25)
ant.p2 = RBA::DPoint::new(0.3, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.25)
ant.p2 = RBA::DPoint::new(1.1, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 3

sample = "e3"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, 0.1, :mode => :round, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.4)
ant.p2 = RBA::DPoint::new(0.3, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, -0.2)
ant.p2 = RBA::DPoint::new(0.3, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.2)
ant.p2 = RBA::DPoint::new(1.1, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 4

sample = "e4"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, -0.1, :mode => :round, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, -0.4)
ant.p2 = RBA::DPoint::new(0.5, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.5, -0.25)
ant.p2 = RBA::DPoint::new(0.5, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.9, -0.25)
ant.p2 = RBA::DPoint::new(0.9, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 5

sample = "e5"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, 0.1, :mode => :octagon, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.4)
ant.p2 = RBA::DPoint::new(0.3, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, -0.2)
ant.p2 = RBA::DPoint::new(0.3, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.1, -0.2)
ant.p2 = RBA::DPoint::new(1.1, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 6

sample = "e6"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, 0.1, :mode => :round, :bias => 0.05, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, -0.4)
ant.p2 = RBA::DPoint::new(0.35, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.35, -0.2)
ant.p2 = RBA::DPoint::new(0.35, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, -0.2)
ant.p2 = RBA::DPoint::new(1.05, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 7

sample = "e7"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, :taper => 10, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.95, -0.4)
ant.p2 = RBA::DPoint::new(0.45, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " 0.6 - 2 x 10°"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.45, -0.25)
ant.p2 = RBA::DPoint::new(0.45, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.95, -0.25)
ant.p2 = RBA::DPoint::new(0.95, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 8

sample = "e8"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 500, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")

substrate = bulk
mask(m1).etch(0.3, :taper => 10, :bias => -0.1, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, -0.4)
ant.p2 = RBA::DPoint::new(0.35, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " 0.8 - 2 x 10°"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.35, -0.25)
ant.p2 = RBA::DPoint::new(0.35, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, -0.25)
ant.p2 = RBA::DPoint::new(1.05, -0.45)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.2, -0.3)
ant.p2 = RBA::DPoint::new(1.2, 0)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.25, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.05)
ant.p2 = RBA::DPoint::new(0.4, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, -0.05)
ant.p2 = RBA::DPoint::new(1.0, 0.2)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.0, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc grow sample 10

sample = "e10"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-1000, -600, 0, 600))

l3 = main_ly.layer(3, 0)
main_top.shapes(l3).insert(RBA::Box::new(600, -600, 2000, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

substrate = bulk

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")
m3 = layer("3/0")

substrate = bulk
mask(m2).etch(0.5, :into => substrate, :taper => 30)
mask(m3).etch(0.5, :into => substrate)

os = substrate.dup

metal = mask(m1).etch(0.3, 0.1, :mode => :round, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
output("1/0", os)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -1.1, 2.1, 0))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 1
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, -0.1)
ant.p2 = RBA::DPoint::new(0.4, -0.1)
ant.style = RBA::Annotation::StyleArrowBoth
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.3, -0.3)
ant.p2 = RBA::DPoint::new(0.3, -0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, -0.3)
ant.p2 = RBA::DPoint::new(0.4, -0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0)
ant.p2 = RBA::DPoint::new(1.3, -0.3)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, 0)
ant.p2 = RBA::DPoint::new(1.35, 0)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.05, -0.3)
ant.p2 = RBA::DPoint::new(1.35, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.05)
ant.p2 = RBA::DPoint::new(0.4, -0.95)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.45)
ant.p2 = RBA::DPoint::new(1.3, -0.95)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, -0.9)
ant.p2 = RBA::DPoint::new(0.4, -0.9)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


# -------------------------------------------------------------------
#  Doc etch sample 12

sample = "e12"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-200, -600, 400, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

# Grow a stop layer
stop = mask(m2).grow(0.05, :into => substrate)

# Grow with mask m1, but only where there is a substrate surface
mask(m1).etch(0.3, 0.1, :mode => :round, :into => substrate)

# output the material data to the target layout
output("0/0", substrate)
output("2/0", stop)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.3)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.25, -0.3)
ant.p2 = RBA::DPoint::new(1.65, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Doc etch sample 13

sample = "e13"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

l2 = main_ly.layer(2, 0)
main_top.shapes(l2).insert(RBA::Box::new(-200, -600, 400, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

# Grow a stop layer
stop = mask(m2).grow(0.05, :into => substrate)

# Grow with mask m1, but only where there is a substrate surface
mask(m1).etch(0.3, 0.1, :mode => :round, :into => substrate, :through => stop)

# output the material data to the target layout
output("0/0", substrate)
output("2/0", stop)
END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.3)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.8, -0.3)
ant.p2 = RBA::DPoint::new(1.65, -0.3)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.05)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

# -------------------------------------------------------------------
#  Doc etch sample 14

sample = "e14"

main_view_index = mw.create_view
main_view = mw.current_view

main_cv = main_view.cellview(main_view.create_layout(false))
main_ly = main_cv.layout
main_top = main_ly.create_cell("TOP")

l1 = main_ly.layer(1, 0)
main_top.shapes(l1).insert(RBA::Box::new(-100, -600, 800, 600))

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(-0.5, 0)
ant.p2 = RBA::DPoint::new(1.5, 0)
ant.style = RBA::Annotation::StyleRuler
main_view.insert_annotation(ant)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
main_view.insert_layer(main_view.end_layers, lp)

main_view.select_cell(main_top.cell_index, 0)
main_view.zoom_fit

configure_view(main_view)

fn = "#{sample}.png"

main_view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"

File.open("tmp.xs", "w") do |file|
  file.puts(<<END);
delta(0.001)

# Specify wafer thickness
depth(1)

# Prepare input layers
m1 = layer("1/0")
m2 = layer("2/0")

substrate = bulk

# Grow with mask m1 into the substrate
mask(m1).etch(0.3, 0.1, :mode => :round, :into => substrate, :buried => 0.4)

# output the material data to the target layout
output("0/0", substrate)

END

end

XSectionScriptEnvironment.new.run_script("tmp.xs")
File.unlink("tmp.xs")

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.8, 2.1, 0.3))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x808080
lp.frame_color = lp.fill_color
lp.source_layer = 0
lp.source_datatype = 0
lp.transparent = true
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 5
lp.fill_color = 0xff8080
lp.frame_color = lp.fill_color
lp.source_layer = 1
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

lp = RBA::LayerProperties::new
lp.dither_pattern = 9
lp.fill_color = 0x8080ff
lp.frame_color = lp.fill_color
lp.source_layer = 2
lp.source_datatype = 0
view.insert_layer(view.end_layers, lp)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.6, 0)
ant.p2 = RBA::DPoint::new(1.6, -0.4)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = " $D"
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.25, -0.4)
ant.p2 = RBA::DPoint::new(1.65, -0.4)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(0.4, 0.2)
ant.p2 = RBA::DPoint::new(0.4, -0.5)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.2)
ant.p2 = RBA::DPoint::new(1.3, -0.5)
ant.style = RBA::Annotation::StyleLine
ant.fmt = ""
view.insert_annotation(ant)

ant = RBA::Annotation::new
ant.p1 = RBA::DPoint::new(1.3, 0.15)
ant.p2 = RBA::DPoint::new(0.4, 0.15)
ant.style = RBA::Annotation::StyleArrowBoth
ant.fmt = "  MASK: $D"
view.insert_annotation(ant)

fn = "#{sample}_xs.png"

configure_view_xs(view)
view.update_content

view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"


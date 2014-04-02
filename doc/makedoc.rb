

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

XSectionGenerator.new("tmp.xs").run

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x202020
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

XSectionGenerator.new("tmp.xs").run

view = mw.current_view
view.zoom_box(RBA::DBox::new(-0.1, -0.6, 2.1, 0.5))

view.clear_layers

lp = RBA::LayerProperties::new
lp.dither_pattern = 2
lp.fill_color = 0x202020
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

view.update_content
view.save_image(fn, screenshot_width, screenshot_height)
puts "Screenshot written to #{fn}"



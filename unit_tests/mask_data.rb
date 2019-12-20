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

# run test with: klayout -b -r mask_data.rb

require "test/unit"

require File.join(File.dirname(__FILE__), "..", "src", "ruby", "xsection.rb")

class TestMaskData < Test::Unit::TestCase
 
  def test_stitch_edges

    e1 = RBA::Edge::new(0, 100, 0, 200)
    e2 = RBA::Edge::new(0, 200, 200, 500)
    e3 = RBA::Edge::new(100, 200, 500, 1000)
    e4 = RBA::Edge::new(0, 0, 100, 200)
    e5 = RBA::Edge::new(200, 500, 0, 600)

    # boundary cases
    assert_equal(XS::MaskData.stitch_edges([ ]).to_s, "[]")
    assert_equal(XS::MaskData.stitch_edges([ RBA::Edge::new ]).to_s, "[[(0,0;0,0)]]")

    assert_equal(XS::MaskData.stitch_edges([ e1 ]).to_s, "[[(0,100;0,200)]]")
    assert_equal(XS::MaskData.stitch_edges([ e1, e2 ]).to_s, "[[(0,100;0,200), (0,200;200,500)]]")
    assert_equal(XS::MaskData.stitch_edges([ e2, e1 ]).to_s, "[[(0,100;0,200), (0,200;200,500)]]")
    assert_equal(XS::MaskData.stitch_edges([ e5, e2, e1 ]).to_s, "[[(0,100;0,200), (0,200;200,500), (200,500;0,600)]]")
    assert_equal(XS::MaskData.stitch_edges([ e2, e3, e4, e1 ]).to_s, "[[(0,0;100,200), (100,200;500,1000)], [(0,100;0,200), (0,200;200,500)]]")
    assert_equal(XS::MaskData.stitch_edges([ e3, e2, e4, e1 ]).to_s, "[[(0,0;100,200), (100,200;500,1000)], [(0,100;0,200), (0,200;200,500)]]")
    assert_equal(XS::MaskData.stitch_edges([ e5, e3, e2, e4, e1 ]).to_s, "[[(0,0;100,200), (100,200;500,1000)], [(0,100;0,200), (0,200;200,500), (200,500;0,600)]]")

  end

  def test_insert_dead_intervals_hill_points

    me = []
    me << RBA::Edge::new(0, 100, 100, 200)
    me << RBA::Edge::new(100, 200, 200, 200)
    me << RBA::Edge::new(200, 200, 200, 300)
    me << RBA::Edge::new(200, 300, 300, 400) # hill point p2
    me << RBA::Edge::new(300, 400, 300, 300) # hill point p1
    me << RBA::Edge::new(300, 300, 500, 200)

    me_saved = me.collect { |e| e.dup }

    dead = XS::MaskData.insert_dead_intervals(me, 100)

    assert_equal(dead.inspect, "[[300, 500]]")
    assert_equal(me.to_s, "[(0,100;100,200), (100,200;200,200), (200,200;200,300), (200,300;300,400), (300,400;500,400), (500,400;500,300), (500,300;700,200)]")

    # sequence is automatically ordered from left to right
    me = me_saved.reverse
    me.each do |e|
      e.swap_points
    end
    dead = XS::MaskData.insert_dead_intervals(me, 100)

    assert_equal(dead.inspect, "[[300, 500]]")
    assert_equal(me.to_s, "[(0,100;100,200), (100,200;200,200), (200,200;200,300), (200,300;300,400), (300,400;500,400), (500,400;500,300), (500,300;700,200)]")

  end

  def test_insert_dead_intervals_hill_edges

    me = []
    me << RBA::Edge::new(0, 100, 100, 200)
    me << RBA::Edge::new(100, 200, 200, 200)
    me << RBA::Edge::new(200, 200, 200, 400)
    me << RBA::Edge::new(200, 400, 300, 400) # hill edge
    me << RBA::Edge::new(300, 400, 500, 300) 
    me << RBA::Edge::new(500, 300, 500, 200)

    dead = XS::MaskData.insert_dead_intervals(me, 500)

    assert_equal(dead.inspect, "[[250, 1250]]")
    assert_equal(me.to_s, "[(0,100;100,200), (100,200;200,200), (200,200;200,400), (200,400;1300,400), (1300,400;1500,300), (1500,300;1500,200)]")

  end

  def test_insert_dead_intervals_both

    me = []
    me << RBA::Edge::new(0, 100, 200, 300)
    me << RBA::Edge::new(200, 300, 300, 400) # hill point p2
    me << RBA::Edge::new(300, 400, 500, 300) # hill point p1
    me << RBA::Edge::new(500, 300, 500, 200) # valley point p2
    me << RBA::Edge::new(500, 200, 600, 300) # valley point p1
    me << RBA::Edge::new(600, 300, 700, 300) # hill edge
    me << RBA::Edge::new(700, 300, 1000, 200)

    me_saved = me.collect { |e| e.dup }

    dead = XS::MaskData.insert_dead_intervals(me, 100)

    assert_equal(dead.inspect, "[[300, 500], [700, 900], [1050, 1250]]")
    assert_equal(me.to_s, "[(0,100;200,300), (200,300;300,400), (300,400;500,400), (500,400;700,300), (700,300;700,200), (700,200;900,200), (900,200;1000,300), (1000,300;1300,300), (1300,300;1600,200)]")

  end

  def test_remove_dead_intervals

    region = RBA::Region::new

    region.insert(RBA::Box::new(0, 0, 1000, 100))
    region.insert(RBA::Box::new(400, 200, 1000, 300))
    region.insert(RBA::Box::new(1200, 200, 2000, 300))
    region.insert(RBA::Box::new(2200, 0, 3000, 1000))

    dead = [ [ 100, 300 ], [ 500, 600 ], [ 1100, 1300 ] ]
    r = XS::MaskData.remove_dead_intervals(region, dead)

    assert_equal(r.to_s, "(0,0;0,100;700,100;700,0);(200,200;200,300;700,300;700,200);(900,200;900,300;1500,300;1500,200);(1700,0;1700,1000;2500,1000;2500,0)")

  end

  def test_remove_dead_intervals_with_holes

    region = RBA::Region::new

    region.insert(RBA::Box::new(0, 0, 1000, 1000))
    region -= RBA::Region::new(RBA::Box::new(400, 200, 800, 300))

    dead = [ [ 100, 300 ], [ 500, 600 ] ]
    r = XS::MaskData.remove_dead_intervals(region, dead)

    assert_equal(r.to_s, "(0,0;0,1000;700,1000;700,0/200,200;500,200;500,300;200,300)")

  end

  def test_compute_convolved_edges_from_sequence_basic

    es = []
    es << RBA::Edge::new(0, 0, 1000, 0)
    
    pts = [ RBA::Point::new(-100, -100), RBA::Point::new(-100, 100), RBA::Point::new(100, 100), RBA::Point::new(100, -100) ]

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, 0)
    assert_equal(r.to_s, "(-100,-100;-100,100;1100,100;1100,-100)")

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, -10)
    assert_equal(r.to_s, "(-110,-100;-110,100;1110,100;1110,-100)")

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, 100)
    assert_equal(r.to_s, "(0,-100;0,100;1000,100;1000,-100)")

  end

  def test_compute_convolved_edges_from_sequence_with_dead_intervals

    es = []
    es << RBA::Edge::new(0, 0, 450, 0)
    es << RBA::Edge::new(450, 0, 450, -100)
    es << RBA::Edge::new(450, -100, 550, -100)
    es << RBA::Edge::new(550, -100, 550, 0)
    es << RBA::Edge::new(550, 0, 1000, 0)
    
    pts = [ RBA::Point::new(-100, -100), RBA::Point::new(-100, 100), RBA::Point::new(100, 100), RBA::Point::new(100, -100) ]

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, 0)
    assert_equal(r.to_s, "(350,-200;350,-100;-100,-100;-100,100;1100,100;1100,-100;650,-100;650,-200)")

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, -10)
    assert_equal(r.to_s, "(340,-200;340,-100;-110,-100;-110,100;1110,100;1110,-100;660,-100;660,-200)")

    r = XS::MaskData::compute_convolved_edges_from_sequence(es, pts, 100)
    assert_equal(r.to_s, "(450,-200;450,-100;0,-100;0,100;450,100;450,0;550,0;550,100;1000,100;1000,-100;550,-100;550,-200)")

  end

  def test_compute_convolved_edges_basic

    es = []
    es << RBA::Edge::new(0, 0, 450, 0)
    es << RBA::Edge::new(450, 0, 450, -100)
    es << RBA::Edge::new(450, -100, 550, -100)
    es << RBA::Edge::new(550, -100, 550, 0)
    es << RBA::Edge::new(600, 0, 700, 0)
    
    pts = [ RBA::Point::new(-100, -100), RBA::Point::new(-100, 100), RBA::Point::new(100, 100), RBA::Point::new(100, -100) ]

    r = XS::MaskData::compute_convolved_edges(es, pts, 100)
    assert_equal(r.to_s, "(450,-200;450,-100;0,-100;0,100;450,100;450,0;550,0;550,-200);(600,-100;600,100;700,100;700,-100)")

  end

end


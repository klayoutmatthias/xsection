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
 
  def test_edge_stitching

    xs = XS::XSectionGenerator::new("ut")

    e1 = RBA::Edge::new(0, 100, 0, 200)
    e2 = RBA::Edge::new(0, 200, 200, 500)
    e3 = RBA::Edge::new(100, 200, 500, 1000)
    e4 = RBA::Edge::new(0, 0, 100, 200)
    e5 = RBA::Edge::new(200, 500, 0, 600)

    assert_equal(XS::MaskData.stitch_edges([ ]).to_s, "[]")
    assert_equal(XS::MaskData.stitch_edges([ e1 ]).to_s, "[(0,100;0,200)]")
    assert_equal(XS::MaskData.stitch_edges([ e1, e2 ]).to_s, "[(0,100;200,500)]")
    assert_equal(XS::MaskData.stitch_edges([ e2, e1 ]).to_s, "[(0,100;200,500)]")
    assert_equal(XS::MaskData.stitch_edges([ e5, e2, e1 ]).to_s, "[(0,100;0,600)]")
    assert_equal(XS::MaskData.stitch_edges([ e2, e3, e4, e1 ]).to_s, "[(0,0;500,1000), (0,100;200,500)]")
    assert_equal(XS::MaskData.stitch_edges([ e3, e2, e4, e1 ]).to_s, "[(0,0;500,1000), (0,100;200,500)]")
    assert_equal(XS::MaskData.stitch_edges([ e5, e3, e2, e4, e1 ]).to_s, "[(0,0;500,1000), (0,100;0,600)]")

  end
 
end



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

# run test with: klayout -b -r layout_data.rb

require "test/unit"

require File.join(File.dirname(__FILE__), "..", "src", "ruby", "xsection.rb")

class TestLayoutData < Test::Unit::TestCase
 
  def test_simple

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)
    assert_equal(ld.data.to_s, "[(0,1000;0,3000;2000,3000;2000,1000)]")

  end

  def test_size

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)
    ld2 = ld.sized(0.5)
    assert_equal(ld2.data.to_s, "[(-500,500;-500,3500;2500,3500;2500,500)]")

    ld2.size(1.0)
    assert_equal(ld2.data.to_s, "[(-1500,-500;-1500,4500;3500,4500;3500,-500)]")

    ld2 = ld.sized(0.5, 1.0)
    assert_equal(ld2.data.to_s, "[(-500,0;-500,4000;2500,4000;2500,0)]")

  end

  def test_clone

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)

    ld2 = ld.dup
    ld2.size(-0.1)
    assert_equal(ld.data.to_s, "[(0,1000;0,3000;2000,3000;2000,1000)]")
    assert_equal(ld2.data.to_s, "[(100,1100;100,2900;1900,2900;1900,1100)]")

  end

  def test_bools

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)

    ldother = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(1000, 0, 3000, 2000)) ], xs)
    assert_equal(ld.and(ldother).data.to_s, "[(1000,1000;1000,2000;2000,2000;2000,1000)]")
    assert_equal(ld.andp(ldother.data).data.to_s, "[(1000,1000;1000,2000;2000,2000;2000,1000)]")
    assert_equal(ld.or(ldother).data.to_s, "[(1000,0;1000,1000;0,1000;0,3000;2000,3000;2000,2000;3000,2000;3000,0)]")
    assert_equal(ld.orp(ldother.data).data.to_s, "[(1000,0;1000,1000;0,1000;0,3000;2000,3000;2000,2000;3000,2000;3000,0)]")
    assert_equal(ld.xor(ldother).data.to_s, "[(1000,0;1000,1000;2000,1000;2000,2000;3000,2000;3000,0), (0,1000;0,3000;2000,3000;2000,2000;1000,2000;1000,1000)]")
    assert_equal(ld.xorp(ldother.data).data.to_s, "[(1000,0;1000,1000;2000,1000;2000,2000;3000,2000;3000,0), (0,1000;0,3000;2000,3000;2000,2000;1000,2000;1000,1000)]")
    assert_equal(ld.not(ldother).data.to_s, "[(0,1000;0,3000;2000,3000;2000,2000;1000,2000;1000,1000)]")
    assert_equal(ld.notp(ldother.data).data.to_s, "[(0,1000;0,3000;2000,3000;2000,2000;1000,2000;1000,1000)]")

  end

  def test_transform

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)

    ld.transform(RBA::Trans::new(100, 200))
    assert_equal(ld.data.to_s, "[(100,1200;100,3200;2100,3200;2100,1200)]")

  end

  def test_raw

    xs = XS::XSectionGenerator::new("ut")

    ld = XS::LayoutData::new([ RBA::Polygon::new(RBA::Box::new(0, 1000, 2000, 3000)) ], xs)
    assert_equal(ld.data.to_s, "[(0,1000;0,3000;2000,3000;2000,1000)]")

    ld.data = RBA::Box::new(0, 100, 200, 300)
    assert_equal(ld.data.to_s, "(0,100;200,300)")

  end
 
end


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

module XS

  class MaskData < LayoutData
  
    def initialize(air_polygons, mask_polygons, xs)
      super([], xs)
      @air_polygons = air_polygons
      @mask_polygons = mask_polygons
    end
  
    def upcast(polygons)
      MaskData.new(@air_polygons, polygons, @xs)
    end
  
    def grow(*args)
  
      # parse the arguments
      (xy, z, into, through, on, taper, bias, mode, buried) = parse_grow_etch_args(args, :grow)
  
      # produce the geometry of the new material
      d = produce_geom(xy, z, into, through, on, taper, bias, mode, buried, :grow)
  
      # prepare the result
      res = MaterialData.new(d, @xs)
      
      # consume material
      if into
        into.each do |i|
          i.sub(res)
          @xs.clean(i)
        end
      else
        @xs.air.sub(res)
        # clean the air material
        @xs.clean(@xs.air)
      end
  
      # clean the grown material
      @xs.clean(res)
  
      return res
  
    end
  
    def etch(*args)
  
      # parse the arguments
      (xy, z, into, through, on, taper, bias, mode, buried) = parse_grow_etch_args(args, :etch)
  
      if !into
        raise "'etch' method: requires an 'into' specification"
      end
  
      # prepare the result
      d = produce_geom(xy, z, into, through, on, taper, bias, mode, buried, :etch)
  
      # produce the geometry of the etched material
      res = MaterialData.new(d, @xs)
      
      # consume material and add to air
      into.each do |i|
        j = LayoutData::new(i.data, @xs)
        i.sub(res)
        # clean the remaining material
        @xs.clean(i)
        j.sub(i)
        @xs.air.add(j)
      end
  
      # clean the air material
      @xs.clean(@xs.air)
  
    end
    
    def parse_grow_etch_args(args, method)
  
      xy = nil
      z = nil
      into = nil
      through = nil
      on = nil
      taper = nil
      bias = nil
      buried = nil
      mode = :square
  
      args.each do |a|
        if a.kind_of?(Hash)
          a.each_pair do |k,v|
            if k == :into
              if !v.kind_of?(Array)
                into = [v]
              else
                into = v
              end
              into.each do |i|
                if !i.kind_of?(MaterialData) 
                  raise "'#{method}' method: 'into' expects a material parameter or an array of such"
                end
              end
            elsif k == :on
              if !v.kind_of?(Array)
                on = [v]
              else
                on = v
              end
              on.each do |i|
                if !i.kind_of?(MaterialData) 
                  raise "'#{method}' method: 'on' expects a material parameter or an array of such"
                end
              end
            elsif k == :through
              if !v.kind_of?(Array)
                through = [v]
              else
                through = v
              end
              through.each do |i|
                if !i.kind_of?(MaterialData) 
                  raise "'#{method}' method: 'through' expects a material parameter or an array of such"
                end
              end
            elsif k == :mode
              mode = v
              if v != :round && v != :square && v != :octagon
                raise "'#{method}' method: 'mode' expects ':round', ':square' or ':octagon'"
              end
            elsif k == :buried
              buried = v.to_f
            elsif k == :taper
              taper = v.to_f
            elsif k == :bias
              bias = v.to_f
            else
              raise "'#{method}' method: undefined parameter key '#{k}'"
            end
          end
        elsif !z
          z = a.to_f
        elsif !xy
          xy = a.to_f
        else
          raise "Too many arguments for '#{method}' method"
        end
      end
  
      if !z
        raise "Too few arguments for '#{method}' method"
      end
  
      if on && (through || into)
        raise "'on' option cannot be combined with 'into' or 'through' option"
      end
  
      [xy || 0.0, z, into, through, on, taper, bias, mode, buried]
  
    end
  
    def produce_geom(xy, z, into, through, on, taper, bias, mode, buried, method)
  
      dbias = @xs.delta_dbu
      
      prebias = 0.0
      if xy < 0.0
        xy = -xy
        prebias += xy
      end
  
      if taper
        d = z * Math.tan(Math::PI / 180.0 * taper)
        prebias += d - xy
        xy = d
      end
  
      # determine the "into" material by joining the data of all "into" specs
      # or taking "air" if required.
      if into
        if into.length == 1
          into_data = into[0].data
        else
          into_data = []
          into.each do |i|
            if into_data.length == 0
              into_data = i.data
            else
              into_data = @ep.safe_boolean_to_polygon(i.data, into_data, RBA::EdgeProcessor::mode_or, true, true)
            end
          end
        end
      else
        into_data = @xs.air.data
      end
  
      # determine the "through" material by joining the data of all "through" specs
      if through
        if through.length == 1
          through_data = through[0].data
        else
          through_data = []
          through.each do |i|
            if through_data.length == 0
              through_data = i.data
            else
              through_data = @ep.safe_boolean_to_polygon(i.data, through_data, RBA::EdgeProcessor::mode_or, true, true)
            end
          end
        end
      end
  
      # determine the "on" material by joining the data of all "on" specs
      if on
        if on.length == 1
          on_data = on[0].data
        else
          on_data = []
          on.each do |i|
            if on_data.length == 0
              on_data = i.data
            else
              on_data = @ep.safe_boolean_to_polygon(i.data, on_data, RBA::EdgeProcessor::mode_or, true, true)
            end
          end
        end
      end
  
      bi = ((bias || 0.0) / @xs.dbu + 0.5).floor.to_i
      if bi != 0
        # for backward compatibility the bias is inverse
        mp = @ep.size_to_polygon(@mask_polygons, -bi, 2, true, true)
      else
        mp = @mask_polygons
      end
      
      pi = (prebias / @xs.dbu + 0.5).floor.to_i
      xyi = (xy / @xs.dbu + 0.5).floor.to_i
      zi = (z / @xs.dbu + 0.5).floor.to_i
  
      # in the "into", "through" and "on" case determine the interface region between self and into
      enabled_by = nil
      if into || through || on
        if on
          enabled_by = on_data
        elsif through
          enabled_by = through_data
        else
          enabled_by = into_data
        end
      end
  
      # compute the surface edges in me
      me = compute_surface_edges(mp, enabled_by, 0)
  
      # produce the same edges in a sized variant ("sized" speaking for the original materials for 
      # use with the full kernel
      if pi > 0
        me_sized = compute_surface_edges(mp, enabled_by, pi)
      else
        me_sized = me
      end
      
      if taper && xyi > 0
  
        kernel_pts = []
        kernel_pts << RBA::Point::new(-xyi, 0)
        kernel_pts << RBA::Point::new(0, zi)
        kernel_pts << RBA::Point::new(xyi, 0)
        kernel_pts << RBA::Point::new(0, -zi)
  
        d = produce_edges_with_kernel(me, me_sized, kernel_pts, pi)
  
      elsif xyi <= 0
  
        d = RBA::Region::new
  
        # TODO: there is no way to do that with a Minkowsky sum currently
        # since polygons cannot be lines except through dirty tricks
        dz = RBA::Point::new(0, zi)
        me.each do |e| 
          d.insert(RBA::Polygon::new([ e.p1 - dz, e.p2 - dz, e.p2 + dz, e.p1 + dz ]))
        end
        if pi != 0
          d.size(-pi, 0, 2)
        end
        d.merge
  
      elsif mode == :round || mode == :octagon
  
        # approximate round corners by 64 points (or less when in the order of delta_dbu) for "round" 
        # and 8 for "octagon"
        # nmin is the minimum number of points required to achieve a resolution of delta_dbu for
        # the circle.
        if mode == :round
          nmin = (Math::PI * Math::sqrt(0.5 * [xyi, zi].max.to_f / @xs.delta_dbu.to_f) + 0.9).to_i
          n = [ 64, [ nmin, 8 ].max ].min
        else
          n = 8
        end
        da = 2.0 * Math::PI / n
        rf = 1.0 / Math::cos(da * 0.5)
        kernel_pts = []
        n.times do |i|
          kernel_pts << RBA::Point::from_dpoint(RBA::DPoint::new(xyi * rf * Math::cos(da * (i + 0.5)), zi * rf * Math::sin(da * (i + 0.5))))
        end
  
        d = produce_edges_with_kernel(me, me_sized, kernel_pts, pi)
  
      elsif mode == :square
  
        kernel_pts = []
        kernel_pts << RBA::Point::new(-xyi, -zi)
        kernel_pts << RBA::Point::new(-xyi, zi)
        kernel_pts << RBA::Point::new(xyi, zi)
        kernel_pts << RBA::Point::new(xyi, -zi)
  
        d = produce_edges_with_kernel(me, me_sized, kernel_pts, pi)
  
      else
        d = RBA::Region::new
      end
  
      if (buried || 0.0).abs > 1e-6
        t = RBA::Trans::new(RBA::Point::new(0, -(buried / @xs.dbu + 0.5).floor.to_i))
        d.transform(t)
      end
  
      if through
        d -= RBA::Region::new(through_data)
      end
  
      d &= RBA::Region::new(into_data)
      
      poly = []
      d.each { |p| poly << p }
      return poly
  
    end
  
    # Produces the edges "sized" with the kernel given by "kernel_pts"
    # As the requirement is to provide "negative kernels" which actually
    # take away layout from the original geometry, we provide the input
    # geometry "pre-shrinked" (negative sizing in horizontal direction).
    # This pre-shrink size is "pi" and the corresponding edges are in 
    # "me_sized". 
    # Pre-shrinking will remove small features which we have to add again. 
    # For this purpose, the original, non-shrinked edges are supplied with 
    # "me". We compute their contributions by applying the kernel per-edge
    # and shrink with pi also per-edge. Later we join these contributions
    # with the original.
    def produce_edges_with_kernel(me, me_sized, kernel_pts, pi)
    
      d = RBA::Region::new
    
      kp = RBA::SimplePolygon::new
      kp.set_points(kernel_pts, true)  # "raw" - don't optimize away
  
      me_sized.each do |e| 
        d.insert(kp.minkowsky_sum(e, false))
      end
      
      if pi > 0
      
        # add contributions from the original edges, but sized after folding with
        # the kernel. This will provide feature contributions from parts which are
        # smaller than the kernel's width. To avoid small-segment artefacts we 
        # stitch edges before we do the computation
        
        MaskData.stitch_edges(me).each do |e| 
          pe = kp.minkowsky_sum(e, false)
          pe_sized = @ep.size_to_polygon([ pe ], -pi, 0, 2, true, true)
          pe_sized.each do |p|
            d.insert(p)
          end
        end
        
      end
        
      d.merge
      d
    
    end
    
    # produces joined edges from a set of edges
    # From a set of edges [p1,q1],[q1,q2],..[qn,p2]
    # produce a single edge [p1,p2]. This method accepts 
    # many edges and joins as many as possible.
    # This method assumes each point is only taken once
    # for p1 and once for p2.
    def self.stitch_edges(me)
    
      me_stitched = []

      p1_to_e = {}
      p2_to_e = {}
      me.each do |e| 
        p1_to_e[e.p1] = e 
        p2_to_e[e.p2] = e 
      end
      
      p1_to_e.each do |p1,e|
        if e && !p2_to_e[p1]
          ee = e.dup
          while en = p1_to_e[ee.p2]
            p1_to_e[ee.p2] = nil
            ee.p2 = en.p2
          end
          me_stitched << ee
        end
      end
      
      me_stitched
    
    end

    # computes the surface edges (the interface between air and some material)
    # "enabled_by" is a material object which needs to touch with the surface
    # in order to enable it. "pi" is a prebias which is applied to the air and
    # enabling material to shrink the contours for later application of a full
    # kernel.
    def compute_surface_edges(mp, enabled_by, pi)

      if pi > 0
      
        ap_sized = @ep.size_to_polygon(@air_polygons, -pi, 0, 2, true, true)
        mp_sized = @ep.size_to_polygon(mp, -pi, 0, 2, true, true)
        ap_masked = @ep.safe_boolean_to_polygon(ap_sized, mp_sized, RBA::EdgeProcessor::mode_and, true, true)
        me = ap_masked.empty? ? RBA::Edges::new : (RBA::Edges::new(ap_masked) - (mp_sized.empty? ? RBA::Edges::new : RBA::Edges::new(mp_sized)))
  
        # consider enabling me_sized edges with "into", "on" or "through" ..
        if enabled_by
          enabled_by_sized = @ep.size_to_polygon(enabled_by, -pi, 0, 2, true, true)
          en_masked_sized = @ep.safe_boolean_to_polygon(mp_sized, enabled_by_sized, RBA::EdgeProcessor::mode_anotb, true, true)
          me &= RBA::Region::new(en_masked_sized).sized(@xs.delta_dbu)
        end
      
      else 
      
        # compute the surface edges in me    
        ap_masked = @ep.safe_boolean_to_polygon(mp, @air_polygons, RBA::EdgeProcessor::mode_and, true, true)
        me = ap_masked.empty? ? RBA::Edges::new : (RBA::Edges::new(ap_masked) - (mp.empty? ? RBA::Edges::new : RBA::Edges::new(mp)))
        
        # consider enabling the surface edges with "into", "on" or "through" ..
        if enabled_by
          en_masked = @ep.safe_boolean_to_polygon(mp, enabled_by, RBA::EdgeProcessor::mode_anotb, true, true)
          me &= RBA::Region::new(en_masked).sized(@xs.delta_dbu)
        end
        
      end
      
      me
      
    end
    
  end
  
end

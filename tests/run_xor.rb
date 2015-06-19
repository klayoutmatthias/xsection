
l1 = RBA::Layout::new
l1.read($a)

l2 = RBA::Layout::new
l2.read($b)

layer_pairs = []

l1.layer_indices.each do |ll1|

  li1 = l1.get_info(ll1)

  ll2 = l2.find_layer(l1.get_info(ll1))
  if !ll2
    raise "Layer #{li1.to_s} of layout #{$a} now present in layout #{$b}"
  end

  layer_pairs << [ ll1, ll2 ]

end

l2.layer_indices.each do |ll2|
  ll1 = l1.find_layer(l2.get_info(ll2))
  if !ll1
    raise "Layer #{li2.to_s} of layout #{$b} now present in layout #{$a}"
  end
end

if l1.top_cell.name != l2.top_cell.name
  raise "Top cell name of layout #{$a} (#{l1.top.name} differs from that of layout #{$b} (#{l2.top_name})"
end

if (l1.dbu - l2.dbu) > 1e-6
  raise "Database unit of layout #{$a} (#{l1.dbu} differs from that of layout #{$b} (#{l2.dbu})"
end

diff = false

layer_pairs.each do |ll1,ll2|

  r1 = RBA::Region::new(l1.top_cell.begin_shapes_rec(ll1))
  r2 = RBA::Region::new(l2.top_cell.begin_shapes_rec(ll2))

  rxor = r1 ^ r2

  if $tol.to_i > 0
    rxor.size(-$tol.to_i)
  end

  if !rxor.is_empty?
    diff = true
    puts "#{rxor.size} differences found on layer #{l1.get_info(ll1).to_s}"
  else
    puts "No differences found on layer #{l1.get_info(ll1).to_s}"
  end

end

if diff
  raise "Differences found between layouts #{$a} and #{$b}"
end


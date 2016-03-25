module Utils
  def hash_subset?(a, b)
    set_a = Set.new(a)
    set_b = Set.new(b)
    set_a.subset?(set_b)
  end
end
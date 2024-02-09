
# Passing Blocks
3.times {puts "hi"} # puts hi 3 times

[4,6,8].each {puts "hi2"} # puts hi2 3 times

[4,6,8].each {|x| if 7 > x then puts (x+1) end}


# Using Blocks
class Foo
  def initialize(max)
    @max = max
  end

  def silly
    yield(4,5) + yield(@max, @max)
  end

  # count how many times to go from base to base+1 base+n to until yielding with the base returns true as long as these times don't exceed @max
  def count base
    if base > @max
      raise "reached amx"
    elsif yield base
      1
    else
      1 + (count(base+1) {|i| yield i})
      # The block just returns the same function given before
      # But it will be passed for the new argument when running this function
    end
  end
end
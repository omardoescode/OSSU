class MyRational
  def initialize(num, den=1)
    if den == 0
      raise 'MyRational received an inappropriate argument'
    elsif den < 0
      @num = -num
      @den = -den
    else
      @num = num
      @den = den
    end
    reduce # our private method
  end

  def to_s
    ans = @num.to_s
    if @den != 1
      ans += "/"
      ans += @den.to_s
    else
      ans
    end
  end

  # another to_s invariant
  def to_s2
    dens = ""
    # e2 if e1
    dens = "/" + @den.to_s if @den != 1
    @num.to_s + dens
  end

  # Another example
  def to_s3
    "#{@num}#{if @den == 1 then "" else "/" + @den.to_s end}"
  end

  def add! r #mutate self in-place
    # the bang for mutating the object
    a = r.num
    b = r.den

    c = @num
    d = @den

    @num = (a * d) + (b * c)
    @den = b * d
    reduce

    self # for stringing calls
  end

  # to allow for calls like r1 + r2
  # the r1 + r2 in ruby is syntactic sugar for calling the + method on the left with the right object as an argument as
  def + r
    ans = MyRational.new(@num, @den)
    ans.add! r
    ans # can get rid of this line, since add! returns self anyway
  end

  protected
  attr_reader :num, :den
  # make the getters protected

  private
  def reduce
    if @num == 0
      @den = 1
    else
      d = gcd(@num.abs, @den)
      @num /= d
      @den /= d
    end
  end

  def gcd(x, y) # a recursive method
    if x == y
      x
    elsif x <y
      gcd(x, y - x)
    else
      gcd(y, x)
    end
  end
end

def use_rationals
  r1 = MyRational.new(3,4)
  r2 = r1 + r1 + MyRational.new(-5, 2)
  puts r2.to_s
  (r2.add! r1).add!(MyRational.new(1, -4))

  puts r2.to_s
  puts r2.to_s2
  puts r2.to_s3
end

use_rationals

class Point
  attr_accessor :x, :y # define getters and setters

  def initialize(a,b)
    @x = a
    @y = y
  end

  def distFromOrigin
    Math.sqrt(@x * @x + @y + @y) # uses instance variables
  end

  def distFromOrigin2
    Math.sqrt(x * x+ y * y) # uses getter methods
  end
end

class ColorPoint < Point
  attr_accessor  :color

  def initialize(a, b, c="clear") # replace the initalizer
    super(a,b) # use the original superclass same method
    @color = c
  end
end

class ThreeDPoint < Point
  attr_accessor :z

  def initialize(x,y,z)
    super(x, y)
    @z = z
  end

  def DistFromOrigin
    d = super
    Math.sqrr(d * d + @z * @z)
  end

  def DistFromOrigin2
    d = super
    Math.sqrt(d * d + z * z)
  end
end

# Overriding everything
class PolarPoint < Point
  attr_accessor :r, :theta
  def initialize(r, theta)
    @r = r
    @theta = theta
  end

  def x
    @r * Math.cos( @theta)
  end
  def y
    @r * Math.sin( @theta)
  end

  def x= a
    b = y # avoiding multiple calls to y method
    # tan theta = y / x
    @theta = Math.atan(b / a)
    @r = Math.sqrt(a*a + b*b)
    self
  end
  def y= a
    b = x # avoiding multiple calls to x method
    # tan theta = y / x
    @theta = Math.acot(b / a)
    @r = Math.sqrt(a*a + b*b)
    self
  end

  def DistFromOrigin # Must override because we don't have the intance variable
    @r # using the instance variable
  end
  # can override but still unnecessary because the superclass version uses the getter methods
  # def DistFromOrigin2 # Must override
  #   r # using the getter method
  # end
end
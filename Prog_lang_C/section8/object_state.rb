class A
  def initalize(f)
    @foo = f
  end
  end
  def m1
    @foo = 0
    # Will either initialize it or mutate it
  end
  def m2 x
    @foo += x
    @bar = 0
  end
  # A getter
  def foo
    @foo
  end

class C
  Dans_Age = 28
  def self.reset_bar
    @@bar = 0
  end

  def initialize(f=0)
    @foo = f
  end

  def m2 x
    @foo += x
    @@bar += 1
  end

  def foo
    @foo
  end

  def bar
    @@bar
  end
end

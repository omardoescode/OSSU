a = [3,4,7, 9]
b = a.map {|x| x + 1}

c = a.map{|x| (lambda {|y| x >= y})} # Currying
puts c[2].call 17
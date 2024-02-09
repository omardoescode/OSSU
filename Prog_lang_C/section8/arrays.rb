# Create an array
a = [3,2,7,9]

a [2] # 7
a [0] # 3
a [4] # nil
a [1000] # nil

# get the size
a [-1] # negative indices is counting from the end
# 9@!attribute


a[6] = 14
# will fill the remaining other preceding indices with nil value

# the pipe operator
c = [2,3,1] | [1,2,3] # removing duplicates in one array

# Create another array
y = Array.new(10)
# a 10-long array filled with nil valuefs

z = Array.new(10) {0} # filled with zeros
b = Array.new(10) {|i| - i} # from 0 to -9

a.push(5) # add to the beginning
a.pop() # remove the last element and returns it
a.shift() # pop but for the first elemenet

# We can alias this array
d = a
e = a + [] # to just copy with no aliasing
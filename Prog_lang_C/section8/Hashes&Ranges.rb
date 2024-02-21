h2 = {"SML"=>1, "Racket"=>2, "Ruby"=>3}
h2.each {|k,v| print k; print " "; puts v}

# ranges
(1..100).inject{|acc,elt| acc+elt}
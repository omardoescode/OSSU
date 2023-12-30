fun incr x = x + 1
fun double x = x * 2

val a_tuple = (incr, double, double(incr 7))
val eighteen = (#2 a_tuple) 9
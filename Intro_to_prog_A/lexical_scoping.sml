val x = 1
fun f y = x + y (* Here x maps to 1, always, no matter where it is called*)
val x = 2 (* x maps to 2, this has nothing to do with the function *)
val y = 3 (* y maps to 3 *)
val z = f(x + y) (* f(2 + 3) = f (5) = 1 + 5 = 6 *)

fun f1 y =
    let val x = y + 1
    in fn z => x + y + z 
    end
fun f2 y =
    let val q = y + 1
    in fn z => q + y + z 
    end

val x = 17
val a1 = (f1 7) 4
val a2 = (f2 7) 4

val x = 1
fun f y = let val x =  y + 1 in fn z => x + y + z end
val x = "hi"
val g = f 7
val x = g 4 

fun filter (f, xs) = 
    case xs of [] => []
    | x::xs' => if f x then x::filter(f, xs') else filter(f, xs')

fun greaterThanX = fn y => y > x (* int -> (int -> bool) *)
fun noNegatives xs = filter(greaterThanX ~ 1, xs)
fun allGreater (xs, n) = filter(fn x => x > n, xs)
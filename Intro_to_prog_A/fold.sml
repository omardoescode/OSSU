(* ('a * 'b -> 'a) * 'a * 'b list -> 'a *)
fun fold (f, acc, xs) =
    case xs of [] => acc
    | x::xs' => fold(f, f(acc, x), xs')

fun f1 xs = fold ((fn (x,y) => x + y), 0, xs) (* sum list *)
fun f2 xs = fold ((fn (x,y) => x andalso y => 0), true, xs) (* every x is non-negative *)


fun f3 (xs, lo, hi) =  (* Count the number of values between li and hi inclusive *)
    fold ((fn (x, y) => x + (if y >= lo andalso y <= hi then 1 else 0)), 0, xs)

fun f4 (xs, s) = (* For all elements, are they less than s *)
    let val i = String.size s
    in 
    fold ((fn (x,y) => x andalso String.size y < i), true, xs)
    end

fun f5 (g, xs) = (* every g(x) is true *)
    fold((fn (x,y) => x andalso g y), true, xs)

fun f4again (xs, s)=  
    let val i = String.size s
    in 
        f5(fn y => String.size y < i, xs)
    end








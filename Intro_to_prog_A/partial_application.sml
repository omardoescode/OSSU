fun sorted3 x y z = z >= y andalso y >= x
fun fold f acc xs = 
    case xs of [] => acc
    | x :: xs' => fold f (f(acc, x)) xs'

val in_nonnegative = sorted3 0 0 (* Waiting for the third argument, it will produce true if it is 0 or higher *)

val sum = fold (fn (x,y) => x + y) 0 (* Waiting for the list, which what the function do *)

fun range i j = if i > j then [] else i :: range (i+1) j

val countup = range 1

fun exists predicate xs =
    case xs of [] => false
    | x::xs' => if (predicate x) then true else exists predicate xs'

val greaterThan3 = exists (fn x => x > 3)
val has_zero = exists (fn x => x = 3)

(* Built-In *)

val incrementAll = List.map (fn x => x + 1)
val removeZeros = List.filter (fn x => x <> 0)

(* val pairWithOne = List.map (fn x => (x, 1)) *)
(* WorkAround *)
fun pairWithOne xs = List.map (fn x => (x, 1)) xs

val pairWithOne:string list -> (string * int) list = List.map(fn x => (x, 1))

(* This won't cause a problem *)
val incrementAndPariWithOne = List.map (fn x => (x + 1, 1))
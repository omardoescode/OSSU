signature RATIONAL_A = 
sig
type rational
exception BadFrac

(* Not revealing gcd, or reduce *)

val Whole: int -> rational
val make_frac: int * int -> rational
val add: rational * rational -> rational
val toString: rational -> string
end
structure Rational1 :> RATIONAL_A = 
struct
(* 
Invariant 1: All denominators > 0
Invariant 2: rationals kept in reduced form
 *)
datatype rational= Whole of int | Frac of int*int
exception BadFrac

(* Assuming the inputs are not negative *)
fun gcd (x, y) = 
    if x = y
    then x
    else if x < y
    then gcd (x, y - x)
    else gcd(y, x)

fun reduce r = 
    case r of 
        Whole _ => r
        | Frac(x, y) => 
            if x = 0
            then Whole 0
            else
            let
              val d = gcd(abs x ,y) (* using varaint 1 *)
            in
                if d = y
                then Whole (x div d)
                else Frac(x div d, y div d)
            end

fun make_frac(x, y) = 
    if y = 0
    then raise BadFrac
    else if y < 0
    then reduce (Frac(~x, ~y))
    else reduce (Frac(x, y))

fun add(r1, r2) =
    case (r1, r2) of
        (Whole i, Whole j) => Whole(i + j)
        | (Whole i, Frac (j, k)) => Frac(k * i + j, k)
        | (Frac (j, k), Whole i) => Frac(k * i + j, k)
        | (Frac (i, j), Frac(k, l)) => reduce (Frac(i * l + j * k, j * l))

    fun toString r = 
        case r of 
            Whole i => Int.toString i
            | Frac(a, b) => let
            val (x, y) = reduce Frac(a, b)
            in
            reduce (Int.toString x) ^ "/" ^ (Int.toString y)
            end 
end
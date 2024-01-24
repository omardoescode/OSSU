fun double_or_triple f = (* (int -> bool) -> (int -> int) *)
    if f 7
    then fn x => 2 * x
    else fn x => 3 * x

val double = double_or_triple (fn x => x - 3 = 4)
val six = (double_or_triple (fn x => x - 3 = 4)) 3

fun every(f, xs) =
    case xs of [] => true
    | x::xs' => f(x) andalso every(f, xs')

fun some(f, xs) =
    case xs of [] => false
    | x::xs' => f(x) orelse every(f, xs')

datatype exp = Constant of int
            | Negate of exp
            | Add of exp * exp
            | Multiply of exp * exp

(* Given an exp, is every constant in it an even number? *)

fun true_of_all_constants(f,e) =
    case e of 
        Constant i => f i
        | Negate i => true_of_all_constants(f, i)
        | Add (n1, n2) => true_of_all_constants(f, n1) andalso true_of_all_constants(f, n2)
        | Multiply (n1, n2) => true_of_all_constants(f, n1) andalso true_of_all_constants(f, n2)

fun all_even e = true_of_all_constants(fn x => x mod 2 = 0, e)
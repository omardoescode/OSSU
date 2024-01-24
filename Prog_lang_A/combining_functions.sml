(* ('b -> 'c) ('a -> 'b) -> ('a -> 'c) *)
fun compose(f,g) = fn x => f(g(x))

(* int -> real *)
fun sqrt_of_abs i = Math.sqrt (Real.fromInt (abs i)) 
(* fun sqrt_of_abs2 i = (Math.sqrt o Real.fromInt o abs) i *)
val sqrt_of_abs2 = (Math.sqrt o Real.fromInt o abs) 

infix |> (* initalize a new operator *)
fun x |> f = f x

fun sqrt_of_abs3 i = 
    i |> abs |> Real.fromInt |> Math.sqrt

fun backup1 (f, g) = fn x => case f x of NONE => g x
                        | SOME y => y

fun backup2 (f,g) = fn x => f x handle _ => g x



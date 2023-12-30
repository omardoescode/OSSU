
fun filter (f, xs) = 
    case xs of [] => []
    | x::xs' => if f x then x::filter(f, xs') else filter(f, xs')

(* A function that filters the strings that are shorter than s *)
fun allShorterThan1(xs, s) = (* string list* string -> string list*)
    filter(fn x => String.size x < String.size s, xs)

fun allShorterThan2(xs, s) =
    let val i = String.size s
    in 
    filter (fn x => string.size x < i, xs)
    end

